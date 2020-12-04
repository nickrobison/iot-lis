//
//  SRBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/2/20.
//

import Foundation
import Combine
import PromiseKit

public protocol SRBackend {
    func getPatients() -> AnyPublisher<SRPerson, Error>
    // swiftlint:disable:next function_parameter_count line_length
    func addPatient(externalID: String, firstName: String, lastName: String, birthDate: Date, street: String, street2: String, city: String, state: String, zipCode: String, county: String, gender: String) -> Promise<SRPerson>
    func getResults() -> AnyPublisher<SRTestResult, Error>
}
