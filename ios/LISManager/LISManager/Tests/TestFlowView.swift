//
//  TestFlow.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI

enum TestFlowState: CaseIterable {
    case initial
    case sampleScan
    case patientID
    case sampleID
    case finish
}

struct TestFlowView: View {
    
    @State var testFlowState: TestFlowState = .initial
    @State private var stateIdx = 0
    
    
    var body: some View {
        VStack {
            Spacer()
            if (self.testFlowState == .initial) {
                InitialTestFlowView()
            } else if (self.testFlowState == .sampleScan) {
                SampleScanView()
            } else if (self.testFlowState == .patientID) {
                PatientBarcodeView()
            } else if (self.testFlowState == .sampleID) {
                SampleBarcodeView()
            } else if (self.testFlowState == .finish) {
                FinishTestFlowView()
            }
            Spacer()
            Button("Click me:") {
                self.incrementState()
            }
        }
    }
    
    private func incrementState() {
        self.stateIdx += 1
        self.testFlowState = TestFlowState.allCases[self.stateIdx]
    }
}

struct TestFlowView_Previews: PreviewProvider {
    static var previews: some View {
        TestFlowView()
    }
}
