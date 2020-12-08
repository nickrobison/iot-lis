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
    func getPatients() -> Promise<[SRPerson]>
    func subscribeToPatient() -> AnyPublisher<SRPerson, Error>
    // swiftlint:disable:next function_parameter_count line_length
    func addPatient(externalID: String, firstName: String, lastName: String, birthDate: Date, street: String, street2: String, city: String, state: String, zipCode: String, county: String, gender: String) -> Promise<SRPerson>
    func addPatientToQueue(id: UUID) -> Promise<Void>
    func add(result: TestResultEnum, on date: Date, to hashedPatientID: String) -> Promise<Void>
    func getResults() -> Promise<[SRTestResult]>
    func subscribeToResults() -> AnyPublisher<SRTestResult, Error>
    func getDevices() -> Promise<[SRDevice]>
}
