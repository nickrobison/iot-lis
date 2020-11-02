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
    init(patient: PatientEntity) {
        self.patient = patient
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showAdd = false
    var body: some View {
        VStack {
            PersonHeader(name: patient.nameComponent, id: patient.id!)
            Divider()
            Text("Orders").font(.headline)
            Divider()
            if patient.orders!.count == 0 {
                Text("No tests yet")
                Spacer()
            } else {
                List(patient.ordersAsArray(), id: \.self) { _ in
                    Text("Test")
                }
            }
            Text("Results").font(.headline)
            Divider()
            if patient.results!.count == 0 {
                Text("No results yet")
                Spacer()
            } else {
                List(patient.ordersAsArray(), id: \.self) { order in
                    ResultRow(order: order)
                }
            }
            Divider()
            Button("Add test") {
                self.showAdd = true
            }
        }
        .padding([.bottom])
        .sheet(isPresented: $showAdd, content: {
            TestFlowView(model: TestFlowModel(self.managedObjectContext, patient: self.patient))
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
        let sample = SampleEntity(context: managedObjectContext)
        sample.id = UUID()
        sample.cartridgeID = msg
        
        let order = OrderEntity(context: managedObjectContext)
        order.sample = sample
        order.patient = patient
        
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
        let patient = PatientEntity()
        patient.lastName = "Robison"
        patient.firstName = "Nicholas"
        patient.results = []
        patient.orders = []
        return patient
    }
}
