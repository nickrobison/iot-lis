//
//  SampleInferenceTests.swift
//  LISManagerTests
//
//  Created by Nick Robison on 11/5/20.
//

import Foundation

import XCTest
import UIKit
@testable import LISManager

class SampleInferenceTests: XCTestCase {
    
    var model = CardModelManager(modelInfo: MobileNetSSD.modelInfo, labelInfo: MobileNetSSD.labelsInfo)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMatchingImage() {
        guard let image = UIImage(named: "Sample Binax Card") else {
            fatalError("Cannot find image")
        }
        
        guard let buffer = image.toPixelBuffer() else {
            fatalError("Cannot convert to pixel buffer")
        }
        
        let results = self.model!.runModel(onFrame: buffer)
        
        switch results {
        case .success(let inferences):
            XCTAssertEqual(1, inferences.count)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testNotMatchingImage() {
        guard let image = UIImage(named: "SampleUSDSForm") else {
            fatalError("Cannot find image")
        }
        
        guard let buffer = image.toPixelBuffer() else {
            fatalError("Cannot convert to pixel buffer")
        }
        
        let results = self.model!.runModel(onFrame: buffer)
        
        switch results {
        case .success(let inferences):
            XCTAssertEqual(0, inferences.count)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    //    func testExample() throws {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //        let model = PatientAddModel()
    //        model.firstName = "Hello"
    //        model.lastName = "Nope"
    //
    //        let exp1 = XCTestExpectation()
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    //            XCTAssertFalse(model.isValid)
    //            exp1.fulfill()
    //        }
    //        wait(for: [exp1], timeout: 5.0)
    //        model.gender = "M"
    //        model.sex = "F"
    //        model.address1 = "hello"
    //        model.city = "Wash"
    //        model.state = "DC"
    //        model.zipCode = "20008"
    //
    //        let exp2 = XCTestExpectation()
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    //            XCTAssertTrue(model.isValid)
    //            exp2.fulfill()
    //        }
    //        wait(for: [exp2], timeout: 5.0)
    //    }
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
