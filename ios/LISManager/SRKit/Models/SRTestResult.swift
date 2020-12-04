//
//  SRTestReport.swift
//  SRKit
//
//  Created by Nick Robison on 12/4/20.
//

import Foundation

public enum TestResultEnum: CaseIterable {
    case positive
    case negative
    case unknown
}

public struct SRTestResult: Identifiable {
    public let id: UUID
    public let patientID: UUID
    public let sampleType: String
    public let dateTested: Date
    public let result: TestResultEnum
    
    public init(id: UUID, patientID: UUID, sampleType: String, dateTested: Date, result: TestResultEnum) {
        self.id = id
        self.patientID = patientID
        self.sampleType = sampleType
        self.dateTested = dateTested
        self.result = result
    }
}
