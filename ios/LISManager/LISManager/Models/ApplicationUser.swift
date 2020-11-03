//
//  ApplicationUser.swift
//  LISManager
//
//  Created by Nick Robison on 11/3/20.
//

import Foundation

struct ApplicationUser {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    
    init?(from response: [String: Any]) {
        guard let id = response["sub"] as? String else {
            return nil
        }
        self.id = id
        
        guard let firstName = response["given_name"] as? String else {
            return nil
        }
        self.firstName = firstName
        guard let lastName = response["family_name"] as? String else {
            return nil
        }
        self.lastName = lastName
        
        guard let username = response["preferred_username"] as? String else {
            return nil
        }
        self.username = username
    }
}
