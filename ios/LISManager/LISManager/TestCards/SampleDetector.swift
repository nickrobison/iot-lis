//
//  SampleDetector.swift
//  LISManager
//
//  Created by Nick Robison on 11/8/20.
//

import Foundation
import Combine
import CoreImage
import UIKit

/// Stores one formatted inference.
struct Inference: Hashable {
    let confidence: Float
    let className: String
    let rect: CGRect
    let displayColor: UIColor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(confidence)
        hasher.combine(className)
        hasher.combine(displayColor)
        
        // This is wrong, I probably need to do some sort of geometry calculation to determine the area of the rect.
        // Or, its central geohash
        hasher.combine(rect.minX)
        hasher.combine(rect.minY)
        hasher.combine(rect.maxX)
        hasher.combine(rect.maxY)
    }
}

enum InferenceError: Error {
    case preprocessError(msg: String)
    case unknown(error: Error)
}

protocol SampleDetector {
    func runModel(onFrame buffer: CVPixelBuffer) -> AnyPublisher<[Inference], InferenceError>
}
