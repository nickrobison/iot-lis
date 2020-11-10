//
//  CoreMLSampleDetector.swift
//  LISManager
//
//  Created by Nick Robison on 11/8/20.
//

import Foundation
import Combine
import VisionKit
import Vision

class CoreMLSampleDetector: SampleDetector {
    
    private let model: VNCoreMLModel
    
    init?() {
        do {
            self.model = try VNCoreMLModel(for: SampleDetector_4(configuration: MLModelConfiguration()).model)
        } catch {
            return nil
        }
    }
    
    func runModel(onFrame buffer: CVPixelBuffer) -> AnyPublisher<[Inference], InferenceError> {
        
        let subject: PassthroughSubject<[Inference], InferenceError> = PassthroughSubject()
        
        let request = VNCoreMLRequest(model: self.model) { [weak self] request, error in
            let results = self?.processClassifications(for: request, error: error)
            subject.send(results ?? [])
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let  handler = VNImageRequestHandler(cvPixelBuffer: buffer, options: [:])
            do {
                try handler.perform([request])
            } catch {
                subject.send(completion: .failure(.unknown(error: error)))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func processClassifications(for request: VNRequest, error: Error?) -> [Inference] {
        guard let results = request.results else {
            return []
        }
        let classifications = results as? [VNRecognizedObjectObservation]
        
        guard let classz = classifications else {
            return []
        }
        
        return classz.map {
            let label = $0.labels[0]
            return Inference(confidence: label.confidence, className: label.identifier, rect: $0.boundingBox, displayColor: .purple)
        }
    }
}
