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
