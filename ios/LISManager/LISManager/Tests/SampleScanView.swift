//
//  SampleScanView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI

struct SampleScanView: View {
    
    @Binding var sampleID: String
    @Binding var testFlowState: TestFlowState
    
    var body: some View {
        VStack {
            Text("Scan your sample")
            self.makeCamera()
        }
    }
    
    private func makeCamera() -> some View {
        let controller = CameraViewController()
        controller.handler = self.handleScan
        return controller
    }
    
    private func handleScan(msg: String) {
        self.sampleID = msg
        self.testFlowState = .patientID
    }
}

struct SampleScanView_Previews: PreviewProvider {
    static var previews: some View {
        SampleScanView(sampleID: .constant("hello there"), testFlowState: .constant(.sampleScan))
    }
}
