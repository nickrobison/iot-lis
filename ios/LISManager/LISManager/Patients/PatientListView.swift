//
//  PatientListView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/21/20.
//

import SwiftUI
import CoreData

struct PatientListView: View {
    
    @FetchRequest(
        entity: PatientEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \PatientEntity.lastName, ascending: true)]
    )
    var patients: FetchedResults<PatientEntity>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            List(patients) { p in
                NavigationLink(destination: PatientDetailView(patient: p)) {
                    Text("\(p.firstName!)-\(p.lastName!)")
//                    PersonCellView(person: patient)
                }
            }
            .navigationBarTitle("Patients")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        debugPrint("clicked")
                                        self.showAdd = true
                                    }, label: { Image(systemName: "plus")}))
        }
        .sheet(isPresented: $showAdd, content: {
            PatientAddView(completionHandler: self.addPatient)
        })
    }
    
    private func addPatient(patient: PatientModel) {
        debugPrint("Patient")
        do {
            _ = patient.toEntity(self.managedObjectContext)
            try self.managedObjectContext.save()
        } catch {
            debugPrint(error)
        }
        
    }
}

struct PatientListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientListView()
    }
}
