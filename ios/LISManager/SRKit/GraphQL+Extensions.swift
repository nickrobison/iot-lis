//
//  GraphQL+Extensions.swift
//  SRKit
//
//  Created by Nick Robison on 12/4/20.
//

import Foundation
import Apollo

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyy-MM-dd"
    return df
}()

extension GraphQLID {
    func uuid() -> UUID {
        UUID.init(uuidString: String(self.utf8))!
    }
}

extension TestResultListQuery.Data.TestResult {
    
    func toSRTestResult() -> SRTestResult {
        
        // We'll need to parse the actual string at some point
        let result = TestResultEnum.positive
        
        let patientID = self.patient?.internalId?.uuid()
        return SRTestResult(id: self.internalId!.uuid(), patientID: patientID!, sampleType: "COVID", dateTested: dateFormatter.date(from: self.dateTested!)!, result: result)
    }
}

extension PatientListQuery.Data.Patient {
    
    func toSRPerson() -> SRPerson {
        let birthDate = dateFormatter.date(from: self.birthDate!)!
        
        return SRPerson(id: self.internalId!.uuid(), firstName: self.firstName!, lastName: self.lastName!,
                        birthday: birthDate,
                        street: self.street!,
                        street2: self.streetTwo!,
                        city: self.city!,
                        state: self.state!,
                        zip: self.zipCode!,
                        gender: self.gender!,
                        orders: [],
                        results: [])
    }
}


