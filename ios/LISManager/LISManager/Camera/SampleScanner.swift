//
//  SampleScanner.swift
//  LISManager
//
//  Created by Nick Robison on 11/9/20.
//

import Foundation
import UIKit
import AVFoundation
import Combine

class SampleScanner: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    
    @Published var inference: Inference?
    var captureSession: AVCaptureSession?
    var camera: AVCaptureDevice?
    var cameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    private lazy var videoDataOutput = AVCaptureVideoDataOutput()
    var completionHandler: (([Inference]) -> Void)?
    var cancellable: AnyCancellable?
    var maskLayer: CAShapeLayer?
    
    private let detector: SampleDetector
    private let bufferSubject = PassthroughSubject<CVPixelBuffer, Never>()
    private let inferenceQueue = DispatchQueue(label: "inferenceQueue", qos: .userInitiated)
    private let sampleBufferQueue = DispatchQueue(label: "sampleBufferQueue", qos: .userInitiated)
    
    init(_ completionHandler: (([Inference]) -> Void)?) {
        self.completionHandler = completionHandler
        self.detector = CoreMLSampleDetector()!
        //        self.detector = TFSampleDetector(modelInfo: MobileNetSSD.modelInfo, labelInfo: MobileNetSSD.labelsInfo)!
        self.completionHandler = completionHandler
    }
    
    deinit {
        self.cancellable?.cancel()
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            self.camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            
            try self.camera?.lockForConfiguration()
            self.camera?.unlockForConfiguration()
            
        }
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let frontCamera = self.camera {
                self.cameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.cameraInput!) {
                    captureSession.addInput(self.cameraInput!)
                } else { throw CameraControllerError.inputsAreInvalid }
                
                // Enable video input
                
                
                self.videoDataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
                videoDataOutput.alwaysDiscardsLateVideoFrames = true
                videoDataOutput.videoSettings = [ String(kCVPixelBufferPixelFormatTypeKey): kCMPixelFormat_32BGRA]
                
                if captureSession.canAddOutput(videoDataOutput) {
                    self.captureSession?.addOutput(videoDataOutput)
                    videoDataOutput.connection(with: .video)?.videoOrientation = .portrait
                } else {
                    throw CameraControllerError.invalidOperation
                }
                
            } else { throw CameraControllerError.noCamerasAvailable }
            
            captureSession.startRunning()
            
        }
        
        DispatchQueue(label: "prepare").async { [weak self] in
            guard let self = self else {
                return
            }
            do {
                // setup the buffer
                self.cancellable = self.bufferSubject
                    .subscribe(on: self.inferenceQueue)
                    .setFailureType(to: InferenceError.self)
                    .flatMap { buffer in
                        self.detector.runModel(onFrame: buffer)
                    }
                    .removeDuplicates()
                    .retry(10) // Sometimes, TF throws an exception, but we don't want to die, we want to keep going
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { _ in
                        // Not used yet
                    }, receiveValue: { value in
                        self.drawInferenceBoxes(value)
                    })
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        self.bufferSubject.send(pixelBuffer)
    }
    
    private func drawInferenceBoxes(_ inferences: [Inference]) {
        guard let inference = inferences.first else {
            return
        }
        debugPrint("I have detected a: \(inference.className) sample")
        
        // Rescale the layer
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -(self.previewLayer?.frame.height ?? 0))
        let scale = CGAffineTransform.identity.scaledBy(x: self.previewLayer?.frame.width ?? 0, y: self.previewLayer?.frame.height ?? 0)
        
        let bounds = inference.rect.applying(scale).applying(transform)
        self.maskLayer?.removeFromSuperlayer()
        
        self.maskLayer = CAShapeLayer()
        self.maskLayer!.frame = bounds
        //        self.maskLayer!.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        self.maskLayer!.cornerRadius = 10
        self.maskLayer!.opacity = 0.75
        self.maskLayer!.borderColor = inference.displayColor.cgColor
        self.maskLayer!.borderWidth = 5.0
        
        self.previewLayer!.insertSublayer(self.maskLayer!, at: 1)
        
        // Send it along
        self.completionHandler?(inferences)
    }
}
