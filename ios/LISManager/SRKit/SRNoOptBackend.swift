//
//  SRNoOptBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/4/20.
//

import Foundation
import Combine
import os

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.SRKit", category: "nooptbackend")

public struct SRNoOtpBackend: SRBackend {
    private static let LOGMSG: StaticString = "Calling no-opt backend, probably not what you want"
    
    public init() {
        // Nothing yet
    }
    
    public func getPatients() -> AnyPublisher<SRPerson, Error> {
        os_log(SRNoOtpBackend.LOGMSG, log: logger, type: .error)
        return Empty<SRPerson, Error>(completeImmediately: true).eraseToAnyPublisher()
    }
    
    public func getResults() -> AnyPublisher<SRTestResult, Error> {
        os_log(SRNoOtpBackend.LOGMSG, log: logger, type: .error)
        return Empty<SRTestResult, Error>(completeImmediately: true).eraseToAnyPublisher()
    }
}
