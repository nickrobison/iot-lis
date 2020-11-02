//
//  FormReader.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/21/20.
//

import os
import Foundation
import Vision
import UIKit

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.FormReader", category: "input")

class FormReader: NSObject {

    func extractText(_ image: UIImage, handler: @escaping (String) -> Void) {
        let request = VNRecognizeTextRequest { (req, error) in
            guard error == nil else {
                os_log("Error detecting text: %s", log: logger, type: .error, error!.localizedDescription)
                return
            }
            
            guard let observations = req.results as? [VNRecognizedTextObservation] else {
                os_log("No observations in image", log: logger, type: .debug)
                return
            }
            
            os_log("I have %d observations", log: logger, type: .debug, observations.count)
            
            var stringResults: [String] = []
            
            for observation in observations {
                guard let best = observation.topCandidates(1).first else {
                    os_log("No recognized candidates", log: logger, type: .debug)
                    return
                }
                os_log("Candidate: %s", log: logger, type: .debug, best.string)
                stringResults.append(best.string)
                
            }
            handler(stringResults.joined(separator: "\n"))
        }
        request.recognitionLevel = .accurate
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            try? handler.perform([request])
        }
    }
    
    private func handleDetection(request: VNRequest, error: Error?) {
        
    }
}
