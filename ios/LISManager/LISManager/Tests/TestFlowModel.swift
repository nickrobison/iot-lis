//
//  TestFlowModel.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/27/20.
//

import Foundation
import CoreData

class TestFlowModel: ObservableObject {
    
    enum TestFlowState: CaseIterable {
        case initial
        case sampleScan
        case patientID
        case sampleID
        case finish
    }
    
    @Published var testFlowState: TestFlowState = .initial
    @Published var stateIdx = 0
    @Published var sampleID = ""
    @Published var readNow = false
    let patient: PatientEntity
    
    private let ctx: NSManagedObjectContext
    
    init(_ ctx: NSManagedObjectContext, patient: PatientEntity) {
        self.ctx = ctx
        self.patient = patient
    }
    
    func addOrder() {
        // Create and save the entity
        let sample = SampleEntity(context: self.ctx)
        sample.id = UUID()
        sample.cartridgeID = self.sampleID
        
        let order = OrderEntity(context: self.ctx)
        order.patient = self.patient
        order.sample = sample
        
        self.ctx.perform {
            do {
                try self.ctx.save()
            } catch {
                debugPrint(error)
            }
        }
    }
}
