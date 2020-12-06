//
//  TestFlowModel.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/27/20.
//

import Foundation
import CoreData
import SRKit

class TestFlowModel: ObservableObject {
    
    enum TestFlowState: CaseIterable {
        case initial
        case sampleScan
        case operatorID
        case patientID
        case sampleID
        case finish
    }
    
    @Published var testFlowState: TestFlowState = .initial
    @Published var stateIdx = 0
    @Published var sampleID = ""
    @Published var readNow = false
    let patient: SRPerson
    let backend: SRBackend
    
    private let ctx: NSManagedObjectContext
    
    init(_ ctx: NSManagedObjectContext, patient: SRPerson, backend: SRBackend) {
        self.ctx = ctx
        self.patient = patient
        self.backend = backend
    }
    
    func addOrder() {
        // Create and save the entity
        let sample = SampleEntity(context: self.ctx)
        sample.id = UUID()
        sample.cartridgeID = self.sampleID
        
        let order = OrderEntity(context: self.ctx)
        order.patientHashedID = self.patient.hashedID
        order.sample = sample
        order.orderDate = Date()
        
        // Add the order to the patient
        
        self.ctx.perform {
            do {
                try self.ctx.save()
            } catch {
                debugPrint(error)
            }
        }
    }
}
