//
//  SampleKitTests.swift
//  SampleKitTests
//
//  Created by Nick Robison on 12/16/20.
//

import XCTest
import UIKit
@testable import SampleKit

class SampleKitTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBinaxRead() throws {
        
        guard let image = UIImage(named: "Binax_Negative", in: Bundle(for: (type(of: self))), with: nil) else {
            fatalError("Cannot find image")
        }
        
        guard let buffer = image.toPixelBuffer() else {
            fatalError("Cannot convert to pixel buffer")
        }
        
        let cl = BinaxClassifier(modelInfo: ("binax", "tflite"))!
        switch cl.runModel(onFrame: buffer) {
        
        case .success(let results):
            XCTAssertEqual("Negative", results[0].label, "Should be a negative test")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
}

extension UIImage {
    
    func toPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData,
                                width: Int(self.size.width),
                                height: Int(self.size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
