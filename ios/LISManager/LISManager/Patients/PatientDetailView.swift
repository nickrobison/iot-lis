//
//  PatientDetailView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: PatientEntity
    
    @FetchRequest(
        entity: SampleEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \SampleEntity.cartridgeID, ascending: true)]
    )
    var samples: FetchedResults<SampleEntity>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showAdd = false
    var body: some View {
        VStack {
            PersonHeader(name: patient.nameComponent, id: patient.id!)
            Divider()
            Text("Samples")
            List(samples, id: \.self) { _ in
                Text("Sample")
            }
            Divider()
            Button("Add sample") {
                self.showAdd = true
            }
            Spacer()
        }
        .sheet(isPresented: $showAdd, content: {
            self.makeCamera()
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
