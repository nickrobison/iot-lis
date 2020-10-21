//
//  CameraViewController.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/21/20.
//

import Foundation
import UIKit
import SwiftUI

final class CameraViewController : UIViewController, UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    
    var controller: BarcodeScanner?
    var previewView: UIView!
    
    override func viewDidLoad() {
        
        self.controller = BarcodeScanner(self.handleScanned)
        
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        
        controller?.prepare { error in
            if let error = error {
                print(error)
            }
            try? self.controller?.displayPreview(on: self.previewView)
        }
        
        
    }
    
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // Not used yet
    }
    
    func handleScanned(value: String) {
        debugPrint(value)
    }
}
