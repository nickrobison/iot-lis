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
struct Inference {
    let confidence: Float
    let className: String
    let rect: CGRect
    let displayColor: UIColor
}

enum InferenceError: Error {
    case preprocessError(msg: String)
    case unknown(error: Error)
}

protocol SampleDetector {
    func runModel(onFrame buffer: CVPixelBuffer) -> AnyPublisher<[Inference], InferenceError>
}
