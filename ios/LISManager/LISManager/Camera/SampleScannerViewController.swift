//
//  SampleScannerViewController.swift
//  LISManager
//
//  Created by Nick Robison on 11/9/20.
//

import Foundation
import UIKit
import SwiftUI

final class SampleScannerViewController: UIViewController, UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SampleScannerViewController
    
    var controller: SampleScanner?
    var previewView: UIView!
    
    var handler: (([Inference]) -> Void)?
    
    override func viewDidLoad() {
        self.controller = SampleScanner(self.handler)
        previewView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        
        controller?.prepare { error in
            if let error = error {
                print(error)
            }
            try? self.controller?.displayPreview(on: self.previewView)
        }
    }
    
    func makeUIViewController(context: Context) -> SampleScannerViewController {
        self
    }
    
    func updateUIViewController(_ uiViewController: SampleScannerViewController, context: Context) {
        // Not used yet
    }
}
