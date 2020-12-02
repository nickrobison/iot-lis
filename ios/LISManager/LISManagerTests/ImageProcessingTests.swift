//
//  ImageProcessingTests.swift
//  LISManagerTests
//
//  Created by Nick Robison on 11/5/20.
//

import Foundation

import VideoToolbox
import XCTest
import UIKit
@testable import LISManager

class ImageProcessingTests: XCTestCase {
    
    func testImageResize() {
        guard let image = UIImage(named: "Sample Binax Card") else {
            fatalError("Cannot find image")
        }
        
        guard let buffer = image.toPixelBuffer() else {
            fatalError("Cannot convert to pixel buffer")
        }
        
        let resized = buffer.resized(to: CGSize(width: 1024, height: 1024))
        
        let i2 = UIImage(pixelBuffer: resized!)
        
        XCTAssertEqual(1024, i2!.size.width, "Should have correct width")
        XCTAssertEqual(1024, i2!.size.height, "Should have correct height")
        
        // Assert that the images are equal
//        guard let resizedImage = UIImage(named: "resized") else {
//            fatalError("Cannot load resized image")
//        }
//        XCTAssertEqual(i2?.pngData(), resizedImage.pngData(), "Images should be equal")
        
    }
}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        guard let img2 = cgImage else {
            return nil
        }
        
        self.init(cgImage: img2)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
