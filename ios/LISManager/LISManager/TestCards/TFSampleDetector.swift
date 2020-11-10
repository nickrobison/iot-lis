//
//  TFSampleDetector.swift
//  LISManager
//
//  Created by Nick Robison on 11/4/20.
//

import os
import Accelerate
import Foundation
import TensorFlowLite
import Combine
import CoreImage

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.CardModelManager", category: "input")

// Tuple of filename and extension
typealias FileInfo = (name: String, extension: String)

/// Information about the MobileNet SSD model.
enum MobileNetSSD {
    static let modelInfo: FileInfo = (name: "mobilenet", extension: "tflite")
    static let labelsInfo: FileInfo = (name: "labels", extension: "txt")
}

class TFSampleDetector: NSObject, SampleDetector {
    
    // image mean and std for floating model, should be consistent with parameters used in model training
    let imageMean: Float = 127.5
    let imageStd: Float = 127.5
    // MARK: Model parameters
    let batchSize = 1
    let inputChannels = 3
    let inputWidth = 640
    let inputHeight = 640
    let threshold: Float = 0.9
    
    /// TensorFlow Lite `Interpreter` object for performing inference on a given model.
    private var interpreter: Interpreter
    private var labels: [String] = []
    
    init?(modelInfo: FileInfo, labelInfo: FileInfo) {
        // Let's try some things
        let modelName = modelInfo.name
        
        guard let modelPath = Bundle.main.path(forResource: modelName, ofType: modelInfo.extension) else {
            os_log("Cannot load model", log: logger, type: .error)
            return nil
        }
        
        // It would be nice to
        
        var delegates: [Delegate] = []
        
        var coremlOptioins = CoreMLDelegate.Options()
        coremlOptioins.coreMLVersion = 3
        coremlOptioins.enabledDevices = .all
        
        if let coreMLDelegate = CoreMLDelegate(options: coremlOptioins) {
            os_log("Initializing CoreML delegate", log: logger, type: .debug)
            delegates.append(coreMLDelegate)
        } else {
            let metalDelegate = MetalDelegate()
            os_log("Initializing Metal delegate", log: logger, type: .debug)
            delegates.append(metalDelegate)
        }
        
        //        var delegate: Delegate? = CoreMLDelegate()
        //        if delegate == nil {
        //            os_log("Initializing Metal delegate", log: logger, type: .debug)
        //            delegate = MetalDelegate()
        //        } else {
        //            os_log("Initializing CoreML delegate", log: logger, type: .debug)
        //        }
        
        var options = Interpreter.Options()
        // Why? Because, why not?
        options.threadCount = 2
        do {
            let start = Date()
            self.interpreter = try Interpreter(modelPath: modelPath, options: options, delegates: delegates)
            //            try interpreter.allocateTensors()
            os_log("Interpreter initialization took: %.2f ms", log: logger, type: .debug, Date().timeIntervalSince(start) * 1000)
        } catch {
            os_log("Cannot create interpreter: %s", log: logger, type: .error, error.localizedDescription)
            return nil
        }
        super.init()
        loadLabels(labelInfo)
    }
    
    func runModel(onFrame buffer: CVPixelBuffer) -> AnyPublisher<[Inference], InferenceError> {
        let subject = PassthroughSubject<[Inference], InferenceError>()
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
            subject.send(completion: .failure(.preprocessError(msg: "Cannot resize image")))
            return subject.eraseToAnyPublisher()
        }
        
        
        DispatchQueue.init(label: "inference", qos: .userInitiated).async {
            
            let outputBoundingBox: Tensor
            let outputClasses: Tensor
            let outputScores: Tensor
            let outputCount: Tensor
            do {
                try self.interpreter.allocateTensors()
                let inputTensor = try self.interpreter.input(at: 0)
                
                // Remove the alpha component
                guard let rgbData = self.rgbDataFromBuffer(scaledPixelBuffer, byteCount: self.batchSize * self.inputWidth * self.inputHeight * self.inputChannels,
                                                           isModelQuantized: inputTensor.dataType == .uInt8) else {
                    subject.send(completion: .failure(.preprocessError(msg: "Cannot remove alpha component")))
                    return
                    //                    return subject.eraseToAnyPublisher()
                }
                
                try self.interpreter.copy(rgbData, toInputAt: 0)
                
                // Run inference by invoking the `Interpreter`.
                let start = DispatchTime.now()
                try self.interpreter.invoke()
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                let interval = Double(nanoTime) / 1_000_000
                os_log("Inference took %.2f ms", log: logger, type: .debug, interval)
                
                outputBoundingBox = try self.interpreter.output(at: 0)
                outputClasses = try self.interpreter.output(at: 1)
                outputScores = try self.interpreter.output(at: 2)
                outputCount = try self.interpreter.output(at: 3)
            } catch {
                os_log("Cannot run inference: %s", log: logger, type: .error, error.localizedDescription)
                subject.send(completion: .failure(.unknown(error: error)))
                return
                //                return subject.eraseToAnyPublisher()
            }
            
            let resultArray = self.formatResults(
                boundingBox: outputBoundingBox.asArray(of: Float.self),
                outputClasses: outputClasses.asArray(of: Float.self),
                outputScores: outputScores.asArray(of: Float.self),
                outputCount: Int(([Float](unsafeData: outputCount.data) ?? [0])[0]),
                width: CGFloat(imageWidth),
                height: CGFloat(imageHeight))
            
            subject.send(resultArray)
        }
        return subject.eraseToAnyPublisher()
    }
    
    private func loadLabels(_ labelInfo: FileInfo) {
        let filename = labelInfo.name
        let fExtension = labelInfo.extension
        
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: fExtension) else {
            os_log("Unable to load model labels", log: logger, type: .error)
            return
        }
        
        do {
            let contents = try String(contentsOf: fileUrl, encoding: .utf8)
            self.labels = contents.components(separatedBy: .newlines)
        } catch {
            os_log("Cannot read file contents: %s", log: logger, type: .error, error.localizedDescription)
        }
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
    
    /// Filters out all the results with confidence score < threshold and returns the top N results
    /// sorted in descending order.
    private func formatResults(boundingBox: [Float], outputClasses: [Float], outputScores: [Float], outputCount: Int, width: CGFloat, height: CGFloat) -> [Inference] { //swiftlint:disable:this function_parameter_count line_length
        
        var resultsArray: [Inference] = []
        if outputCount == 0 {
            return resultsArray
        }
        
        for i in 0...outputCount - 1 { //swiftlint:disable:this identifier_name
            let score = outputScores[i]
            
            guard score >= self.threshold else {
                continue
            }
            
            let outputClassIndex = Int(outputClasses[i])
            let outputClass = self.labels[outputClassIndex + 1]
            
            var rect = CGRect.zero
            
            // Translates the detected bounding box to CGRect.
            rect.origin.y = CGFloat(boundingBox[4*i])
            rect.origin.x = CGFloat(boundingBox[4*i+1])
            rect.size.height = CGFloat(boundingBox[4*i+2]) - rect.origin.y
            rect.size.width = CGFloat(boundingBox[4*i+3]) - rect.origin.x
            
            let newRect = rect.applying(CGAffineTransform(scaleX: width, y: height))
            
            let inference = Inference(confidence: score, className: outputClass, rect: newRect, displayColor: .purple)
            
            resultsArray.append(inference)
        }
        
        resultsArray.sort { (first, second) in
            return first.confidence > second.confidence
        }
        
        return resultsArray
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
