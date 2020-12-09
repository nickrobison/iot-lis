//
//  SRPerson+Extensions.swift
//  LISManager
//
//  Created by Nick Robison on 12/3/20.
//

import Foundation
import CoreData
import SRKit

extension SRPerson {
    
    init(lastName: String, firstName: String) {
        self.init(id: UUID.init(), firstName: firstName, lastName: lastName, birthday: Date.init(), street: "", street2: "", city: "", state: "", zip: "", gender: "", orders: [], results: [])
    }
    
    var nameComponent: PersonNameComponents {
        get { // swiftlint:disable:this implicit_getter
            var nameComp = PersonNameComponents()
            nameComp.familyName = self.lastName
            nameComp.givenName = self.firstName
            return nameComp
        }
    }
}
