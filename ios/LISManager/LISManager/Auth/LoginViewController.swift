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

enum AuthenticationError: Error {
    case invalidState(String)
    case invalidData
    case oktaError(Error)
    case keychainError(Error)
}

final class LoginViewController: UIViewController, UIViewControllerRepresentable {
    public static let UserKey = "okta_user"
    typealias UIViewControllerType = LoginViewController
    
    var stateManager: OktaOidcStateManager?
    var oktaOidc: OktaOidc?
    let secureStorage = OktaSecureStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oktaOidc = try? OktaOidc()
        self.loadFromKeychain()
    }
    
    func loginUser(handler: @escaping ((Result<ApplicationUser, AuthenticationError>) -> Void)) {
        // Start login
        self.oktaOidc?.signInWithBrowser(from: self) { stateManager, error in
            
            if let error = error {
                handler(.failure(.oktaError(error)))
                return
            }
            self.stateManager = stateManager
            
            guard let authStateData = try? NSKeyedArchiver.archivedData(withRootObject: self.stateManager!, requiringSecureCoding: false) else {
                handler(.failure(.invalidData))
                return
            }
            
            do {
                try self.secureStorage.set(data: authStateData, forKey: LoginViewController.UserKey)
            } catch let error as NSError {
                handler(.failure(.keychainError(error)))
                return
            }
            
            guard let sManager = self.stateManager else {
                handler(.failure(.invalidState("State manager should not be nil")))
                return
            }
            
            sManager.getUser { response, error in
                if let error = error {
                    handler(.failure(.oktaError(error)))
                    return
                }
                
                guard let response = response else {
                    handler(.failure(.invalidState("User response is empty")))
                    return
                }
                
                response.forEach { key, value in
                    debugPrint("Key: \(key). Value: \(value)")
                }
                
                guard let user = ApplicationUser(from: response) else {
                    handler(.failure(.invalidData))
                    return
                }
                handler(.success(user))
            }
            
        }
    }
    
    func logoutUser(handler: @escaping ((AuthenticationError?) -> Void)) {
        guard let stateManager = self.stateManager else {
            return
        }
        
        self.oktaOidc?.signOutOfOkta(stateManager, from: self) { error in
            if let error = error {
                handler(.oktaError(error))
                return
            }
            stateManager.clear()
            try? self.secureStorage.clear()
            self.stateManager = nil
            handler(nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> LoginViewController {
        return self
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        // Not used
    }
    
    private func loadFromKeychain() {
        DispatchQueue.global().async {
            do {
                let authStateData = try self.secureStorage.getData(key: LoginViewController.UserKey)
                guard let stateManager = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(authStateData) as? OktaOidcStateManager else {
                    return
                }
                self.stateManager = stateManager
            } catch let error as NSError {
                debugPrint("Error: \(error)")
                return
            }
        }
    }
    
    class Coordinator {
        var parent: LoginViewController
        
        init(_ parent: LoginViewController) {
            self.parent = parent
        }
    }
}
