//
//  SampleBarcodeView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI

struct SampleBarcodeView: View {
    
    let sampleID: String
    
    var body: some View {
        VStack {
            Text("Scan the sample ID")
            QRCodeView(msg: sampleID)
        }
    }
}

struct SampleBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        SampleBarcodeView(sampleID: "This is a sample ID, really cool, isn't it")
    }
}
