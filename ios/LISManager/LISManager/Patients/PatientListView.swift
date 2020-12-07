//
//  PatientListView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/21/20.
//

import SwiftUI
import SRKit
import Combine

struct PatientListView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.srBackend) var backend: SRBackend
    @State private var patients: [SRPerson] = []
    @State private var showAdd = false
    @State private var cancel: AnyCancellable?
    
    var body: some View {
        NavigationView {
            List(patients) { patient in
                NavigationLink(destination: PatientDetailView(patient: patient)) {
                    Text("\(patient.firstName), \(patient.lastName)")
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
        .onAppear {
            self.cancel = self.backend.subscribeToPatient()
                .assertNoFailure()
                .collect()
                .sink(receiveValue: { value in
                    debugPrint("Adding values")
                    self.patients = value
                })
        }
        .sheet(isPresented: $showAdd, content: {
            PatientAddView(model: PatientAddModel(backend: backend), completionHandler: self.addPatient)
        })
    }
    
    private func addPatient(patient: SRPerson) {
        debugPrint("Add Patient")
        self.patients.append(patient)
    }
}

struct PatientListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientListView()
    }
}
