//
//  BinaxClassifier.swift
//  SampleKit
//
//  Created by Nick Robison on 12/16/20.
//

import os
import Accelerate
import Foundation
import TensorFlowLite
import Combine
import CoreImage

/// An inference from invoking the `Interpreter`.
struct Inference {
  let confidence: Float
  let label: String
}

/// An error returned either by invoking the `Interpreter` or in preprocessing
enum InferenceError: Error {
    case preprocessError(msg: String)
    case inferenceError(error: Error)
}

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.SampleKit", category: "BinaxClassifier")

typealias FileInfo = (name: String, extension: String)

class BinaxClassifier {
    
    // image mean and std for floating model, should be consistent with parameters used in model training
    let imageMean: Float = 127.5
    let imageStd: Float = 127.5
    // MARK: Model parameters
    let batchSize = 1
    let inputChannels = 3
    let inputWidth = 1024
    let inputHeight = 1024
    let threshold: Float = 0.9
    let resultCount = 3
    
    private var interpreter: Interpreter
    private var queue: DispatchQueue
    
    private let labels = ["Positive", "Negative", "Inconclusive"]
    
    init?(modelInfo: FileInfo) {
        let modelName = modelInfo.name
        
        let bundle = Bundle(for: type(of: self))
        
        guard let modelPath = bundle.path(forResource: modelName, ofType: modelInfo.extension) else {
            os_log("Cannot load model", log: logger, type: .error)
            return nil
        }
        
        var options = Interpreter.Options()
        // Why? Because, why not?
        options.threadCount = 2
        do {
            let start = Date()
            self.interpreter = try Interpreter(modelPath: modelPath, options: options)
            os_log("Interpreter initialization took: %.2f ms", log: logger, type: .debug, Date().timeIntervalSince(start) * 1000)
        } catch {
            os_log("Cannot create interpreter %s", log: logger, type: .error, error.localizedDescription)
            return nil
        }
        
        self.queue = DispatchQueue.init(label: "binaxClassifier", qos: .userInitiated)
    }
    
    func runModel(onFrame buffer: CVPixelBuffer) -> Result<[Inference], InferenceError> {
        let imageWidth = CVPixelBufferGetWidth(buffer)
        let imageHeight = CVPixelBufferGetHeight(buffer)
        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(buffer)
        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
                sourcePixelFormat == kCVPixelFormatType_32BGRA ||
                sourcePixelFormat == kCVPixelFormatType_32RGBA)
        
        let imageChannels = 4
        assert(imageChannels >= inputChannels)
        
        // Crops the image to the biggest square in the center and scales it down to model dimensions.
        let scaledSize = CGSize(width: inputWidth, height: inputHeight)
        guard let scaledPixelBuffer = buffer.resized(to: scaledSize) else {
            // Catch errors here
            return .failure(.preprocessError(msg: "Cannot rescale image"))
        }
        
        //        self.queue.async {
        do {
            try self.interpreter.allocateTensors()
            let inputTensor = try self.interpreter.input(at: 0)
            
            // Remove the alpha component
            guard let rgbData = self.rgbDataFromBuffer(scaledPixelBuffer, byteCount: self.batchSize * self.inputWidth * self.inputHeight * self.inputChannels,
                                                       isModelQuantized: inputTensor.dataType == .uInt8) else {
                // Catch errors here
                return .failure(.preprocessError(msg: "Cannot remove Alpha component from image"))
            }
            
            try self.interpreter.copy(rgbData, toInputAt: 0)
            
            // Run inference
            let start = DispatchTime.now()
            try self.interpreter.invoke()
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let interval = Double(nanoTime) / 1_000_000
            os_log("Inference took %.2f ms", log: logger, type: .debug, interval)
            
            let outputTensor = try self.interpreter.output(at: 0)
            let results = outputTensor.asArray(of: Float.self)
            
            let inferences = getTopN(results: results)
            return .success(inferences)
        } catch {
            return .failure(.inferenceError(error: error))
        }
        //        }
    }
    
    // MARK: - Private methods
    
    /// Returns the top N inference results sorted in descending order.
    private func getTopN(results: [Float]) -> [Inference] {
      // Create a zipped array of tuples [(labelIndex: Int, confidence: Float)].
      let zippedResults = zip(labels.indices, results)

      // Sort the zipped results by confidence value in descending order.
      let sortedResults = zippedResults.sorted { $0.1 > $1.1 }.prefix(resultCount)

      // Return the `Inference` results.
      return sortedResults.map { result in Inference(confidence: result.1, label: labels[result.0]) }
    }
    
    private func rgbDataFromBuffer(_ buffer: CVPixelBuffer, byteCount: Int, isModelQuantized: Bool) -> Data? {
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
        }
        guard let sourceData = CVPixelBufferGetBaseAddress(buffer) else {
            return nil
        }
        
        let width = CVPixelBufferGetWidth(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let desintationChannelCount = 3
        let destinationBytesPerRow = desintationChannelCount * width
        
        var sourceBuffer = vImage_Buffer(data: sourceData, height: UInt(height), width: UInt(width), rowBytes: sourceBytesPerRow)
        
        guard let destinationData = malloc(height * destinationBytesPerRow) else {
            os_log("Cannot malloc sufficient bytes", log: logger, type: .error)
            return nil
        }
        defer {
            free(destinationData)
        }
        
        var destinationBuffer = vImage_Buffer(data: destinationData, height: UInt(height), width: UInt(width), rowBytes: destinationBytesPerRow)
        
        if CVPixelBufferGetPixelFormatType(buffer) == kCVPixelFormatType_32BGRA {
            vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
        } else if CVPixelBufferGetPixelFormatType(buffer) == kCVPixelFormatType_32ARGB {
            vImageConvert_ARGB8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
        }
        
        let byteData = Data(bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)
        if isModelQuantized {
            return byteData
        }
        
        // Not quantized, convert to floats
        // Let's try to be clever and use Accelerate
        let bytes = [UInt8](unsafeData: byteData)!
        var floats = [Float](repeating: .nan, count: destinationBuffer.rowBytes * height)
        // Convert from UInt8 to Float
        vDSP.convertElements(of: bytes, to: &floats)
        
        // Create vectors for multiplication and subtraction
        let meanVec = [Float](repeating: imageMean, count: floats.count)
        // Invert the Image standard deviation so we can use multiplication, rather than division
        let meanStdDev = [Float](repeating: (1.0  / imageStd), count: floats.count)
        
        var results = [Float](repeating: .nan, count: floats.count)
        vDSP.multiply(subtraction: (floats, meanVec), meanStdDev, result: &results)
        
        return Data(copyingBufferOf: results)
    }
}

// MARK: - Extensions

extension Data {
    /// Creates a new buffer by copying the buffer pointer of the given array.
    ///
    /// - Warning: The given array's element type `T` must be trivial in that it can be copied bit
    ///     for bit with no indirection or reference-counting operations; otherwise, reinterpreting
    ///     data from the resulting buffer has undefined behavior.
    /// - Parameter array: An array with elements of type `T`.
    init<T>(copyingBufferOf array: [T]) {
        self = array.withUnsafeBufferPointer(Data.init)
    }
}

extension Tensor {
    /// Creates a new array of primitive types from the underlying Tensor data
    /// Returns an empty array if the initializer fails
    func asArray<T>(of type: T.Type) -> [T] {
        [T](unsafeData: self.data) ?? []
    }
}

extension Array {
    /// Creates a new array from the bytes of the given unsafe data.
    ///
    /// - Warning: The array's `Element` type must be trivial in that it can be copied bit for bit
    ///     with no indirection or reference-counting operations; otherwise, copying the raw bytes in
    ///     the `unsafeData`'s buffer to a new array returns an unsafe copy.
    /// - Note: Returns `nil` if `unsafeData.count` is not a multiple of
    ///     `MemoryLayout<Element>.stride`.
    /// - Parameter unsafeData: The data containing the bytes to turn into an array.
    init?(unsafeData: Data) {
        guard unsafeData.count % MemoryLayout<Element>.stride == 0 else { return nil }
        self = unsafeData.withUnsafeBytes { .init($0.bindMemory(to: Element.self)) }
    }
}
