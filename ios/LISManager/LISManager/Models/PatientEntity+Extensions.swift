//
//  PatientEntity+Extensions.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import Foundation

extension PatientEntity {
    var nameComponent: PersonNameComponents {
        get { // swiftlint:disable:this implicit_getter
            var nameComp = PersonNameComponents()
            nameComp.familyName = self.lastName
            nameComp.givenName = self.firstName
            return nameComp
        }
    }

    func unwrapOrders() -> OrderEntity {
        return ordersAsArray().first!
    }
    
    func ordersAsArray() -> [OrderEntity] {
        // swiftlint:disable:next force_cast
        return self.orders?.allObjects as! [OrderEntity]
    }
    
    func resultsAsArray() -> [ResultEntity] {
        // swiftlint:disable:next force_cast
        return self.results?.allObjects as! [ResultEntity]
    }
}
