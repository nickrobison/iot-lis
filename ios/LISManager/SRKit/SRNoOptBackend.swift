//
//  SRNoOptBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/4/20.
//

import Foundation
import Combine
import PromiseKit
import os

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.SRKit", category: "nooptbackend")

public struct SRNoOtpBackend: SRBackend {

    private static let LOGMSG: StaticString = "Calling no-opt backend, probably not what you want"
    
    public init() {
        // Nothing yet
    }
    
    public func getPatients() -> Promise<[SRPerson]> {
        os_log(SRNoOtpBackend.LOGMSG, log: logger, type: .error)
        return Promise<[SRPerson]> { seal in
            seal.fulfill([])
        }
    }
    
    public func subscribeToPatient() -> AnyPublisher<SRPerson, Error> {
        os_log(SRNoOtpBackend.LOGMSG, log: logger, type: .error)
        return Empty<SRPerson, Error>(completeImmediately: true).eraseToAnyPublisher()
    }
    
    // swiftlint:disable:next function_parameter_count line_length
    public func addPatient(externalID: String, firstName: String, lastName: String, birthDate: Date, street: String, street2: String, city: String, state: String, zipCode: String, county: String, gender: String) -> Promise<SRPerson> {
        os_log(SRNoOtpBackend.LOGMSG, log: logger, type: .error)
        return Promise<SRPerson> { seal in
            seal.reject("Cannot add patients")
        }
    }
    
    public func getResults() -> AnyPublisher<SRTestResult, Error> {
        os_log(SRNoOtpBackend.LOGMSG, log: logger, type: .error)
        return Empty<SRTestResult, Error>(completeImmediately: true).eraseToAnyPublisher()
    }
    
    public func add(result: TestResultEnum, on date: Date, to hashedPatientID: String) -> Promise<Void> {
        os_log(SRNoOtpBackend.LOGMSG, log: logger, type: .error)
        return Promise<Void> { seal in
            seal.reject("Cannot add test results")
        }
    }
}
