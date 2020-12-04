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
    public let orders: [SRTestOrder]
    public let results: [SRTestResult]
    
    public init(id: UUID, firstName: String, lastName: String, birthday: Date, street: String, street2: String, city: String, state: String, zip: String, gender: String, orders: [SRTestOrder], results: [SRTestResult]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.street = street
        self.street2 = street2
        self.city = city
        self.state = state
        self.zip = zip
        self.gender = gender
        self.orders = orders
        self.results = results
    }
}
