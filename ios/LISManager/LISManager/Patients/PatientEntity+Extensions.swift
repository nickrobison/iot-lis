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
    
    func unwrapSamples() -> SampleEntity {
        let samples = self.samples?.allObjects as! [SampleEntity]
        return samples.first!
    }
}
