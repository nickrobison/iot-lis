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

private let isoDateFormatter: ISO8601DateFormatter = {
    let df = ISO8601DateFormatter()
    df.formatOptions = [.withInternetDateTime,
                                   .withDashSeparatorInDate,
                                   .withFullDate,
                                   .withFractionalSeconds]
    return df
}()

extension GraphQLID {
    func uuid() -> UUID {
        UUID.init(uuidString: self)!
    }
}

extension TestResultListQuery.Data.TestResult {
    
    func toSRTestResult() -> SRTestResult {
        
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let patient = self.patient!
        
        let pid = patient.internalId!
        let id = self.internalId!
        let tested = self.dateTested!
        // FIXME: This is nonsense, why doesn't it parse????????
        let dString = isoDateFormatter.string(from: Date())
        let dateTested = df.date(from: dString)
        let result = TestResultEnum(rawValue: self.result!)
        return SRTestResult(id: UUID(uuidString: id)!, patientID: UUID(uuidString: pid)!, sampleType: "COVID", dateTested: Date(), result: result!)
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

extension DeviceListQuery.Data.DeviceType {
    
    func toSRDevice() -> SRDevice {
        return SRDevice(id: self.internalId!.uuid(), manufacturer: self.manufacturer!, model: self.model!, loincCode: self.loincCode!)
    }
}

extension Date {
    func toGraphQLDate() -> String {
        dateFormatter.string(from: self)
    }
}
