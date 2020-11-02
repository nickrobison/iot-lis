//
//  PatientEntity+Extensions.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import Foundation

extension PatientEntity {
    var nameComponent: PersonNameComponents {
        get {
            var nc = PersonNameComponents()
            nc.familyName = self.lastName
            nc.givenName = self.firstName
            return nc
        }
    }
    
    func unwrapOrders() -> OrderEntity {
        return ordersAsArray().first!
    }
    
    func ordersAsArray() -> [OrderEntity] {
        return self.orders?.allObjects as! [OrderEntity]
    }
    
    func resultsAsArray() -> [ResultEntity] {
        return self.results?.allObjects as! [ResultEntity]
    }
}
