//
//  CVPixelBuffer+Extensions.swift
//  SampleKit
//
//  Created by Nick Robison on 12/16/20.
//

import Foundation
import AVFoundation
import Accelerate

extension CVPixelBuffer {
    
    func resized(to size: CGSize) -> CVPixelBuffer? {
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        
        let pixelBufferType = CVPixelBufferGetPixelFormatType(self)
        
        assert(pixelBufferType == kCVPixelFormatType_32BGRA ||
                pixelBufferType == kCVPixelFormatType_32ARGB)
        
        let inputImageRowBytes = CVPixelBufferGetBytesPerRow(self)
        let imageChannels = 4
        
        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        
        defer {
            CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        }
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(self) else {
            return nil
        }
        
        // Gets vImage Buffer from input image
        var inputVImageBuffer = vImage_Buffer(data: baseAddress, height: UInt(height), width: UInt(width), rowBytes: inputImageRowBytes)
        
        let scaledImageRowBytes = Int(size.width) * imageChannels
        guard let scaledImageBytes = malloc(Int(size.height) * scaledImageRowBytes) else {
            return nil
        }
        
        // Allocates a vImage buffer for scaled image.
        var scaledVImageBuffer = vImage_Buffer(data: scaledImageBytes, height: UInt(size.height), width: UInt(size.width), rowBytes: scaledImageRowBytes)
        
        // Performs the scale operation on input image buffer and stores it in scaled image buffer.
        let scaleError = vImageScale_ARGB8888(&inputVImageBuffer, &scaledVImageBuffer, nil, vImage_Flags(0))
        
        guard scaleError == kvImageNoError else {
            return nil
        }
        
        let releaseCallback: CVPixelBufferReleaseBytesCallback = { _, pointer in
            
            if let pointer = pointer {
                free(UnsafeMutableRawPointer(mutating: pointer))
            }
        }
        
        var scaledPixelBuffer: CVPixelBuffer?
        
        let converstionStatus = CVPixelBufferCreateWithBytes(nil, Int(size.width), Int(size.height),
                                                             pixelBufferType, scaledImageBytes, scaledImageRowBytes, releaseCallback, nil, nil, &scaledPixelBuffer)
        
        guard converstionStatus == kCVReturnSuccess else {
            free(scaledImageBytes)
            return nil
        }
        
        return scaledPixelBuffer
    }
}

