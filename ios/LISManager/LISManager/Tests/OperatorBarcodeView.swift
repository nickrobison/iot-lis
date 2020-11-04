//
//  OperatorBarcodeView.swift
//  LISManager
//
//  Created by Nick Robison on 11/4/20.
//

import SwiftUI

struct OperatorBarcodeView: View {
    let operatorID: String
    var body: some View {
        VStack {
            Text("Scan the operator ID")
            QRCodeView(msg: operatorID)
            Text(operatorID).font(.callout).foregroundColor(.gray)
        }
    }
}

struct OperatorBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        OperatorBarcodeView(operatorID: "test-operator")
    }
}
