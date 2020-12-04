//
//  SRPerson.swift
//  SRKit
//
//  Created by Nick Robison on 12/2/20.
//

import Foundation

public struct SRPerson: Identifiable {
    public let id: UUID
    public let firstName: String
    public let lastName: String
    public let birthday: Date
    public let street: String
    public let street2: String
    public let city: String
    public let state: String
    public let zip: String
    public let gender: String
}
