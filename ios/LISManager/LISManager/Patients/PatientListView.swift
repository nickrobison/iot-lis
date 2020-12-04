//
//  PatientListView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/21/20.
//

import SwiftUI
import SRKit

struct PatientListView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.srBackend) private var backend
    @State private var patients: [SRPerson] = []
    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            List(patients) { patient in
                NavigationLink(destination: PatientDetailView(patient: patient)) {
                    Text("\(patient.firstName)-\(patient.lastName)")
                    //                    PersonCellView(person: patient)
                }
                .isDetailLink(true)
            }
            .navigationBarTitle("Patients")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        debugPrint("clicked")
                                        self.showAdd = true
                                    }, label: { Image(systemName: "plus")}))
        }
        .onReceive(self.backend.getPatients().assertNoFailure(), perform: { patient in
            self.patients.append(patient)
        })
        .sheet(isPresented: $showAdd, content: {
            PatientAddView(completionHandler: self.addPatient)
        })
    }
    
    private func addPatient(patient: PatientModel) {
        debugPrint("Add Patient")
//        do {
//            _ = patient.toEntity(self.managedObjectContext)
//            try self.managedObjectContext.save()
//        } catch {
//            debugPrint(error)
//        }
    }
}

struct PatientListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientListView()
    }
}
