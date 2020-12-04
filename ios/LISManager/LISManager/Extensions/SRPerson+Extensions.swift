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
    
    func toEntity(_ ctx: NSManagedObjectContext) -> PatientEntity {
        let patient = PatientEntity(context: ctx)
        return patient
    }
}
