//
//  PatientDetailView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI
import CoreData
import SRKit

struct PatientDetailView: View {
    
    let patient: SRPerson
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.srBackend) var backend: SRBackend
    @State private var showAdd = false
    
    private var orders: FetchRequest<OrderEntity>
    
    init(patient: SRPerson) {
        self.patient = patient
        
        self.orders = FetchRequest<OrderEntity>(entity: OrderEntity.entity(),
                                                sortDescriptors: [NSSortDescriptor(keyPath: \OrderEntity.orderDate, ascending: false)],
                                                predicate: NSPredicate(format: "patientHashedID == %@", self.patient.hashedID))
    }
    
    var body: some View {
        VStack {
            PersonHeader(name: patient.nameComponent, id: patient.hashedID)
            Divider()
            Text("Orders").font(.headline)
            Divider()
            if self.orders.wrappedValue.count == 0 {
                Text("No tests yet")
                Spacer()
            } else {
                List(self.orders.wrappedValue, id: \.self) { _ in
                    Text("Test")
                }
            }
            Text("Results").font(.headline)
            Divider()
            if patient.results.count == 0 {
                Text("No results yet")
                Spacer()
            } else {
                List(patient.results) { order in
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
            TestFlowView(model: TestFlowModel(self.managedObjectContext, patient: self.patient, backend: backend))
        })
    }
    
    private func makeCamera() -> some View {
        let controller = CameraViewController()
        controller.handler = self.handleScan
        return controller
    }
    
    private func handleScan(msg: String) {
        //        self.showAdd = false
        //
        //        // Create and save the entity
        //        let sample = SampleEntity(context: managedObjectContext)
        //        sample.id = UUID()
        //        sample.cartridgeID = msg
        //
        //        let order = OrderEntity(context: managedObjectContext)
        //        order.sample = sample
        //        order.patient = patient
        //
        //        do {
        //            try managedObjectContext.save()
        //        } catch {
        //            debugPrint(error)
        //        }
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailView(patient: PatientDetailView_Previews.samplePatient())
    }
    
    private static func samplePatient() -> SRPerson {
        return SRPerson(lastName: "Robison", firstName: "Nicholas")
    }
}
