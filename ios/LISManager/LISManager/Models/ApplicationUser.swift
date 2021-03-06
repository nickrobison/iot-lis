//
//  ApplicationUser.swift
//  LISManager
//
//  Created by Nick Robison on 11/3/20.
//

import Foundation
import xxHash_Swift

struct ApplicationUser: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    
    init(id: String, firstName: String, lastName: String, username: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
    }
    
    init?(from response: [String: Any]) {
        guard let id = response["sub"] as? String else {
            return nil
        }
        self.id = XXH32.digestHex(id)
        
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
    
    func toComponent() -> PersonNameComponents {
        var components = PersonNameComponents()
        components.givenName = self.firstName
        components.familyName = self.lastName
        return components
    }
}
