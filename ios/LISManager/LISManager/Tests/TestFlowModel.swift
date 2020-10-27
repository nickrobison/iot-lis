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
    
    func addSample() {
        // Create and save the entity
        let entity = SampleEntity(context: self.ctx)
        entity.id = UUID()
        entity.cartridgeID = self.sampleID
        entity.patient = self.patient
        
        self.ctx.perform {
            do {
                try self.ctx.save()
            } catch {
                debugPrint(error)
            }
        }
    }
}
