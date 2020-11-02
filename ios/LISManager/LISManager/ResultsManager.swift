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

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.ResultsManager", category: "results")

class ResultsManager: ObservableObject {
    
    private let ctx: NSManagedObjectContext
    private let cancel: AnyCancellable?
    
    @Published var pub: String?
    
    init(ctx: NSManagedObjectContext) {
        self.ctx = ctx
        self.cancel = NotificationCenter.Publisher(center: .default, name: BluetoothManager.resultNotification, object: nil)
            .sink{ v in
                ctx.perform {
                    // Try to match result with sample and patient
                    let value = v.object as! LIS_Protocols_TestResult
                    let patient = value.patient!
//                    let order = value.order!.toEntity(ctx)
                    let result = value.results(at: 0)!.toEntity(ctx)
                    
                    guard let sample_id = value.order?.orderId else {
                        os_log("Result does not have sample ID", log: logger, type: .error)
                        return
                    }
                    guard let patient_id = patient.patientId else {
                        os_log("Result does not have patient ID", log: logger, type: .error)
                        return
                    }
                    
                    // Try to match against patient and and sample
                    let patient_req = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
                    patient_req.predicate = NSPredicate(format: "id = %@", patient_id)
                    
                    let sample_req = NSFetchRequest<SampleEntity>(entityName: "SampleEntity")
                    sample_req.predicate = NSPredicate(format: "cartridgeID = %@", sample_id)
                    let sample = try? ctx.fetch(sample_req).first
                    
                    if sample == nil {
                        os_log("Cannot fetch sample", log: logger, type: .error)
                    }
                    let pEntity = try? ctx.fetch(patient_req).first
                    
                    if pEntity == nil {
                        os_log("Cannot fetch patient", log: logger, type: .error)
                    }
                    
                    guard let order = sample?.order else {
                        os_log("Sample does not have attached order", log: logger, type: .error)
                        return
                    }
                    
                    
                    result.patient = pEntity
                    result.sample = sample
                    result.order = order
                    order.sampleType = value.order?.testTypeName
                    order.addToResults(result)
                    pEntity?.addToOrders(order)
                    
                    do {
                        try ctx.save()
                        os_log("Saved result", log: logger, type: .debug)
                    } catch {
                        os_log("Cannot save new result: %s", log: logger, type: .error, error.localizedDescription)
                    }
                }
            }
    }
    
    private func receiveValue(_ value: LIS_Protocols_Result) {
        
        
        // Send a notification
    }
}
