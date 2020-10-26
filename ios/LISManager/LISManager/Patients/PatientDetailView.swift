//
//  PatientDetailView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI
import CoreData

struct PatientDetailView: View {
    let patient: PatientEntity
    
    var samples: FetchRequest<SampleEntity>
    
    init(patient: PatientEntity) {
        self.patient = patient
        self.samples = FetchRequest<SampleEntity>(
            entity: SampleEntity.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \SampleEntity.cartridgeID, ascending: true)],
            predicate: NSPredicate(format: "patient = %@", patient))
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showAdd = false
    var body: some View {
        VStack {
            PersonHeader(name: patient.nameComponent, id: patient.id!)
            Divider()
            if (samples.wrappedValue.isEmpty) {
                Text("No tests yet")
                Spacer()
            } else {
                List(samples.wrappedValue, id: \.self) { _ in
                    Text("Test")
                }
            }
            
            Divider()
            Button("Add test") {
                self.showAdd = true
            }
        }
        .padding([.bottom])
        .sheet(isPresented: $showAdd, content: {
            TestFlowView(patient: patient, completionHandler: self.handleScan)
        })
    }
    
    private func makeCamera() -> some View {
        let controller = CameraViewController()
        controller.handler = self.handleScan
        return controller
    }
    
    private func handleScan(msg: String) {
        self.showAdd = false
        
        // Create and save the entity
        let entity = SampleEntity(context: managedObjectContext)
        entity.id = UUID()
        entity.cartridgeID = msg
        entity.patient = patient
        
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint(error)
        }
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailView(patient: PatientDetailView_Previews.samplePatient())
    }
    
    private static func samplePatient() -> PatientEntity {
        let p = PatientEntity()
        p.lastName = "Robison"
        p.firstName = "Nicholas"
        return p
    }
}
