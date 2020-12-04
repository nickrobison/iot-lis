//
//  SRBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/2/20.
//

import Foundation
import Combine

public protocol SRBackend {
    func getPatients() -> AnyPublisher<SRPerson, Error>
    func getResults() -> AnyPublisher<SRTestResult, Error>
}
