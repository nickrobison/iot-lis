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
            self.model = try VNCoreMLModel(for: SampleDetector_2(configuration: MLModelConfiguration()).model)
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
        
        guard let classz = classifications?.first else {
            return []
        }
        
        let label = classz.labels[0]
        let inf = Inference(confidence: label.confidence, className: label.identifier, rect: classz.boundingBox, displayColor: .purple)
        return [inf]
    }
}
