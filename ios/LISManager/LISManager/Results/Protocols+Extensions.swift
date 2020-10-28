//
//  Protocols+Extensions.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation
import LISKit
import FlatBuffers
import CoreData
//
//extension LIS_Protocols_Header : Hashable {
//    public static func == (lhs: LIS_Protocols_Header, rhs: LIS_Protocols_Header) -> Bool {
//        return false
////        return lhs.fwVersion == rhs.fwVersion && lhs.name == rhs.name && lhs.processingId == rhs.processingId
//    }
//    
//    public func hash(into hasher: inout Hasher) {
////        hasher.combine(self.fwVersion)
////        hasher.combine(self.name)
////        hasher.combine(self.processingId)
//    }
//}
//
//extension LIS_Protocols_Order : Hashable {
//    public static func == (lhs: LIS_Protocols_Order, rhs: LIS_Protocols_Order) -> Bool {
//        return lhs.orderId == rhs.orderId && lhs.sampleType == rhs.sampleType && lhs.sequenceNumber == rhs.sequenceNumber && lhs.testTypeName == rhs.testTypeName
//    }
//    
//    public func hash(into hasher: inout Hasher) {
////        hasher.combine(self.operatorId)
////        hasher.combine(self.orderId)
////        hasher.combine(self.sampleType)
////        hasher.combine(self.sequenceNumber)
////        hasher.combine(self.testTypeName)
//    }
//    
//    
//}
//
//extension LIS_Protocols_TestResult : Hashable {
//    public static func == (lhs: LIS_Protocols_TestResult, rhs: LIS_Protocols_TestResult) -> Bool {
//        return lhs.header == rhs.header && lhs.order == rhs.order
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.header)
//        hasher.combine(self.order)
//    }
//}

struct OrderInformation {
    let orderID: String
    let testType: String
}

extension LIS_Protocols_Order {
    func toOrderInformation() -> OrderInformation {
        return OrderInformation(orderID: self.orderId ?? "(no id)", testType: self.testTypeName!)
    }
    
    func toEntity(_ ctx: NSManagedObjectContext) -> OrderEntity {
        let entity = OrderEntity(context: ctx)
        entity.orderID = self.orderId
        entity.sampleType = self.testTypeName
        return entity
    }
}

struct ResultInformation {
    let resultType: String
    let value: String
    let resultDate: Date
}

extension LIS_Protocols_Result {
    func toResultInformation() -> ResultInformation {
        let ts = self.timestamp
        return ResultInformation(resultType: self.testResultType ?? "unknown",
                                 value: self.testValue ?? "unknown",
                                 resultDate: Date.init(timeIntervalSince1970: TimeInterval(ts)))
    }
    
    func toEntity(_ ctx: NSManagedObjectContext) -> ResultEntity {
        let entity = ResultEntity(context: ctx)
        
        entity.resultDate = Date.init(timeIntervalSince1970: TimeInterval(self.timestamp))
        entity.result = self.testValue
        entity.resultType = self.testResultType
        entity.units = self.testUnits
        
        return entity
    }
}
