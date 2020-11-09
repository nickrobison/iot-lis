//
//  SampleInferenceTests.swift
//  LISManagerTests
//
//  Created by Nick Robison on 11/5/20.
//

import Foundation

import XCTest
import UIKit
import Combine
@testable import LISManager

class SampleInferenceTests: XCTestCase {
    
    var model: SampleDetector? = TFSampleDetector(modelInfo: MobileNetSSD.modelInfo, labelInfo: MobileNetSSD.labelsInfo)
    //    var model: SampleDetector? = CoreMLSampleDetector()
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMatchingImage() {
        guard let image = UIImage(named: "binax-7") else {
            fatalError("Cannot find image")
        }
        
        guard let buffer = image.toPixelBuffer() else {
            fatalError("Cannot convert to pixel buffer")
        }
        
        let results = self.model!.runModel(onFrame: buffer)
        
        let exp1 = XCTestExpectation()
        
        results
            .sink(receiveCompletion: { error in
                switch error {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp1.fulfill()
            }, receiveValue: { inferences in
                XCTAssertEqual(1, inferences.count)
                XCTAssertEqual("binax", inferences[0].className)
                exp1.fulfill()
            }).store(in: &cancellables)
        
        wait(for: [exp1], timeout: 10)
    }
    
    func testQuidelMatchingImage() {
        guard let image = UIImage(named: "Sample Quidel") else {
            fatalError("Cannot find image")
        }
        
        guard let buffer = image.toPixelBuffer() else {
            fatalError("Cannot convert to pixel buffer")
        }
        
        let results = self.model!.runModel(onFrame: buffer)
        
        let exp1 = XCTestExpectation()
        
        results
            .sink(receiveCompletion: { error in
                switch error {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp1.fulfill()
            }, receiveValue: { inferences in
                XCTAssertEqual(1, inferences.count)
                XCTAssertEqual("quidel", inferences[0].className)
                exp1.fulfill()
            }).store(in: &cancellables)
        
        wait(for: [exp1], timeout: 19)
    }
    
    func testNotMatchingImage() {
        guard let image = UIImage(named: "Not Quidel") else {
            fatalError("Cannot find image")
        }
        
        guard let buffer = image.toPixelBuffer() else {
            fatalError("Cannot convert to pixel buffer")
        }
        
        let results = self.model!.runModel(onFrame: buffer)
        
        let exp1 = XCTestExpectation()
        
        results
            .sink(receiveCompletion: { error in
                switch error {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp1.fulfill()
            }, receiveValue: { inferences in
                XCTAssertEqual(0, inferences.count)
                exp1.fulfill()
            }).store(in: &cancellables)
        
        wait(for: [exp1], timeout: 10)
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
