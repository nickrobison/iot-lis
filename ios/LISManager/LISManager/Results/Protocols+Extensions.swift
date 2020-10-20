//
//  Protocols+Extensions.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation
import LISKit
import FlatBuffers

extension LIS_Protocols_Header : Hashable {
    public static func == (lhs: LIS_Protocols_Header, rhs: LIS_Protocols_Header) -> Bool {
        return lhs.fwVersion == rhs.fwVersion && lhs.name == rhs.name && lhs.processingId == rhs.processingId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.fwVersion)
        hasher.combine(self.name)
        hasher.combine(self.processingId)
    }
}

extension LIS_Protocols_Order : Hashable {
    public static func == (lhs: LIS_Protocols_Order, rhs: LIS_Protocols_Order) -> Bool {
        return lhs.operatorId == rhs.operatorId && lhs.orderId == rhs.orderId && lhs.sampleType == rhs.sampleType && lhs.sequenceNumber == rhs.sequenceNumber && lhs.testTypeName == rhs.testTypeName
    }
    
    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.operatorId)
//        hasher.combine(self.orderId)
//        hasher.combine(self.sampleType)
//        hasher.combine(self.sequenceNumber)
//        hasher.combine(self.testTypeName)
    }
    
    
}

extension LIS_Protocols_TestResult : Hashable {
    public static func == (lhs: LIS_Protocols_TestResult, rhs: LIS_Protocols_TestResult) -> Bool {
        return lhs.header == rhs.header && lhs.order == rhs.order
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.header)
        hasher.combine(self.order)
    }
}

struct OrderInformation {
    let orderID: String
    let testType: String
}

extension LIS_Protocols_Order {
    func toOrderInformation() -> OrderInformation {
        return OrderInformation(orderID: self.orderId ?? "(no id)", testType: self.testTypeName!)
    }
}
