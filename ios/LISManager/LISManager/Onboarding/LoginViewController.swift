//
//  LoginViewController.swift
//  LISManager
//
//  Created by Nick Robison on 11/3/20.
//

import Foundation
import UIKit
import SwiftUI
import OktaOidc
import OktaStorage

final class LoginViewController: UIViewController, UIViewControllerRepresentable {
    typealias UIViewControllerType = LoginViewController
    
    var stateManager: OktaOidcStateManager?
    var oktaOidc: OktaOidc?
    var handler: ((ApplicationUser) -> Void)?
    private let secureStorage = OktaSecureStorage()
    
    override func viewDidLoad() {
        self.oktaOidc = try? OktaOidc()
        
        // Start login
        self.oktaOidc?.signInWithBrowser(from: self) { stateManager, error in
            
            if let error = error {
                debugPrint("Error logging in: \(error)")
                return
            }
            self.stateManager = stateManager
            
            guard let authStateData = try? NSKeyedArchiver.archivedData(withRootObject: self.stateManager!, requiringSecureCoding: false) else {
                return
            }
            
            do {
                try self.secureStorage.set(data: authStateData, forKey: "okta_user",
                                           behindBiometrics: self.secureStorage.isTouchIDSupported() || self.secureStorage.isFaceIDSupported())
            } catch let error as NSError {
                debugPrint("Error setting storage: \(error)")
                return
            }
            
            guard let sManager = self.stateManager else {
                return
            }
            
            sManager.getUser { response, _ in
                guard let response = response else {
                    debugPrint("Cannot get user")
                    return
                }
                
                response.forEach { key, value in
                    debugPrint("Key: \(key). Value: \(value)")
                }
                
                guard let user = ApplicationUser(from: response) else {
                    debugPrint("Cannot convert to user")
                    return
                }
                self.handler?(user)
            }
            
        }
    }
    
    func makeUIViewController(context: Context) -> LoginViewController {
        let controller = LoginViewController()
        controller.handler = self.handler
        return controller
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        // Not used
    }
}
