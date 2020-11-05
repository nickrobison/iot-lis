//
//  TesetCardScanner.swift
//  LISManager
//
//  Created by Nick Robison on 11/4/20.
//

import Foundation
import AVFoundation

class TestCardScanner: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Converts the CMSampleBuffer to a CVPixelBuffer.
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)

        guard let imagePixelBuffer = pixelBuffer else {
          return
        }
        
        // Run the model
        self.runModel(onPixelBuffer: imagePixelBuffer)
    }
    
    private func runModel(onPixelBuffer buffer: CVPixelBuffer) {
        
    }
    
}
