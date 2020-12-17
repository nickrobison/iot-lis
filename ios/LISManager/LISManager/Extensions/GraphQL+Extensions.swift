//
//  GraphQL+Extensions.swift
//  LISManager
//
//  Created by Nick Robison on 12/17/20.
//

import Foundation
import SRKit

extension GetFacilitiesQuery.Data.Organization.TestingFacility {
    func toSRFacility() -> SRFacility {
        return SRFacility(id: UUID.init(uuidString: self.id!)!, name: self.name!, street: self.street!)
    }
}
