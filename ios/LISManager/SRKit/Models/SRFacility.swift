//
//  SRFacility.swift
//  SRKit
//
//  Created by Nick Robison on 12/17/20.
//

import Foundation

public struct SRFacility: Identifiable {
    public let id: UUID
    public let name: String
    public let street: String
    
    public init(id: UUID, name: String, street: String) {
        self.id = id
        self.name = name
        self.street = street
    }
}
