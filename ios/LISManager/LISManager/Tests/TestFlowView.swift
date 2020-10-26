//
//  TestFlow.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI
import UIKit

enum TestFlowState: CaseIterable {
    case initial
    case sampleScan
    case patientID
    case sampleID
    case finish
}

struct TestFlowView: View {
    let patient: PatientEntity
    
    @State var testFlowState: TestFlowState = .initial
    @State private var stateIdx = 0
    @State private var screenBrightness = CGFloat(0.0)
    @State private var sampleID = ""
    
    var completionHandler: ((String) -> Void)?
    
    
    var body: some View {
        VStack {
            buildView().padding([.top])
        }
    }
    
    private func buildView() -> some View {
        VStack {
            Spacer()
            if (self.testFlowState == .initial) {
                InitialTestFlowView()
            } else if (self.testFlowState == .sampleScan) {
                SampleScanView(sampleID: $sampleID, testFlowState: $testFlowState)
            } else if (self.testFlowState == .patientID) {
                PatientBarcodeView(patientID: "123345")
            } else if (self.testFlowState == .sampleID) {
                SampleBarcodeView(sampleID: sampleID)
            } else if (self.testFlowState == .finish) {
                FinishTestFlowView()
            }
            Spacer()
            Button(self.buttonText(), action: self.handleClick)
        }
                .onAppear {
                    // Stash the current brightness value
                    self.screenBrightness = UIScreen.main.brightness
                    UIScreen.main.brightness = CGFloat(1.0)
                }
                .onDisappear {
                    UIScreen.main.brightness = self.screenBrightness
                }
    }
    
    private func buttonText() -> String {
        guard self.testFlowState == .finish else {
            return "Next"
        }
        return "Finish"
    }
    
    private func handleClick() {
        if (self.testFlowState == .finish) {
            self.completionHandler?(self.sampleID)
        } else {
            self.incrementState()
        }
    }
    
    private func incrementState() {
        self.stateIdx += 1
        self.testFlowState = TestFlowState.allCases[self.stateIdx]
    }
}

struct TestFlowView_Previews: PreviewProvider {
    static var previews: some View {
        TestFlowView(patient: buildPatient())
    }
    
    static func buildPatient() -> PatientEntity {
        let e = PatientEntity()
        e.id = "12345"
        return e
    }
}
