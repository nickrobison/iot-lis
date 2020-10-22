//
//  PatientDetailView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: PatientEntity
    var body: some View {
        VStack {
            PersonHeader(name: patient.nameComponent)
            Divider()
            Text("Samples")
            Divider()
            Button("Add sample") {
                debugPrint("Button clicked")
            }
            Spacer()
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
