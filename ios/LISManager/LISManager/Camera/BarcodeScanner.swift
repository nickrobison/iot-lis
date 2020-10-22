//
//  BarcodeScanner.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/21/20.
//

import os
import Foundation
import UIKit
import AVFoundation

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.BarcodeScanner", category: "input")

enum CameraControllerError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}

class BarcodeScanner : NSObject, AVCaptureMetadataOutputObjectsDelegate, ObservableObject {
    @Published var barcode: String?
    var captureSession: AVCaptureSession?
    var camera: AVCaptureDevice?
    var cameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var completionHandler: ((String) -> Void)?
    
    init(_ completionHandler: ((String) -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession(){
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
                
                if captureSession.canAddInput(self.cameraInput!) { captureSession.addInput(self.cameraInput!)}
                else { throw CameraControllerError.inputsAreInvalid }
                
                // Enable qr code scanning
                let metadataOutput = AVCaptureMetadataOutput()
                guard captureSession.canAddOutput(metadataOutput) else {
                    os_log("Cannot add metadata", log: logger, type: .error)
                    return
                }
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.metadataObjectTypes = [.qr, .pdf417, .dataMatrix]
                // Should be on its own queue?
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                
            }
            else { throw CameraControllerError.noCamerasAvailable }
            
            captureSession.startRunning()
            
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
            }
            
            catch {
                DispatchQueue.main.async{
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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let stringValue = readableObject.stringValue else {
                return
            }
            os_log("Received barcode value: %s", log: logger, type: .debug, stringValue)
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.captureSession?.stopRunning()
            self.completionHandler?(stringValue)
        }
    }
}
