//
//  PatientBarcodeView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI

struct PatientBarcodeView: View {
    let patientID: String
    var body: some View {
        VStack {
            Text("Scan the patient ID")
            QRCodeView(msg: patientID)
        }
    }
}

struct PatientBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        PatientBarcodeView(patientID: "8e5ef8c4")
    }
}
