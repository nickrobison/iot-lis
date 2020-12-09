//
//  ResultsManager.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/23/20.
//

import os
import Foundation
import CoreData
import Combine
import LISKit

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager", category: "results")

class ResultsManager: ObservableObject {
    
    private let ctx: NSManagedObjectContext
    private let cancel: AnyCancellable?
    
    @Published var pub: String?
    
    init(ctx: NSManagedObjectContext) {
        self.ctx = ctx
        self.cancel = NotificationCenter.Publisher(center: .default,
                                                   name: BluetoothManager.resultNotification, object: nil)
            .sink { value in
                ctx.perform {
                    // Try to match result with sample and patient
                    // swiftlint:disable:next force_cast
                    let value = value.object as! LIS_Protocols_TestResult
                    let patient = value.patient!
                    //                    let order = value.order!.toEntity(ctx)
                    let result = value.results(at: 0)!.toEntity(ctx)
                    
                    guard let sampleID = value.order?.orderId else {
                        os_log("Result does not have sample ID", log: logger, type: .error)
                        return
                    }
                    guard let patientID = patient.patientId else {
                        os_log("Result does not have patient ID", log: logger, type: .error)
                        return
                    }

                    let sampleReq = NSFetchRequest<SampleEntity>(entityName: "SampleEntity")
                    sampleReq.predicate = NSPredicate(format: "cartridgeID = %@", sampleID)
                    let sample = try? ctx.fetch(sampleReq).first
                    
                    if sample == nil {
                        os_log("Cannot fetch sample", log: logger, type: .error)
                        return
                    }

                    guard let order = sample!.order else {
                        os_log("Sample does not have attached order", log: logger, type: .error)
                        return
                    }
                    result.sample = sample
                    result.order = order
                    result.patientHashedID = patientID
                    order.sampleType = value.order?.testTypeName
                    order.addToResults(result)

                    do {
                        try ctx.save()
                        os_log("Saved result", log: logger, type: .debug)
                    } catch {
                        os_log("Cannot save new result: %s", log: logger, type: .error, error.localizedDescription)
                    }
                }
            }
    }
}
