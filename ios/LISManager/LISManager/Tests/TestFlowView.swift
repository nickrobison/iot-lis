//
//  TestFlow.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI
import UIKit

struct TestFlowView: View {
    @ObservedObject var model: TestFlowModel
    @Environment(\.presentationMode) var presentationMode

    @State private var screenBrightness = CGFloat(0.0)

    var body: some View {
        VStack {
            buildView().padding([.top])
        }
    }
    
    private func buildView() -> some View {
        VStack {
            Spacer()
            if self.model.testFlowState == .initial {
                InitialTestFlowView()
            } else if self.model.testFlowState == .sampleScan {
                SampleScanView(sampleID: self.$model.sampleID, testFlowState: self.$model.testFlowState,
                               stateIdx: self.$model.stateIdx)
            } else if self.model.testFlowState == .operatorID {
                OperatorBarcodeView(operatorID: "test-operator")
            } else if self.model.testFlowState == .patientID {
                PatientBarcodeView(patientID: self.model.patient.id!)
            } else if self.model.testFlowState == .sampleID {
                SampleBarcodeView(sampleID: self.model.sampleID)
            } else if self.model.testFlowState == .finish {
                FinishTestFlowView(readNow: self.$model.readNow)
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
        guard self.model.testFlowState == .finish else {
            return "Next"
        }
        return "Finish"
    }
    
    private func handleClick() {
        if self.model.testFlowState == .finish {
            self.model.addOrder()
            self.presentationMode.wrappedValue.dismiss()
        } else {
            self.incrementState()
        }
    }
    
    private func incrementState() {
        self.model.stateIdx += 1
        self.model.testFlowState = TestFlowModel.TestFlowState.allCases[self.model.stateIdx]
    }
}

//struct TestFlowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestFlowView(model: TestFlowModel(), patient: buildPatient())
//    }
//
//    static func buildPatient() -> PatientEntity {
//        let e = PatientEntity()
//        e.id = "12345"
//        return e
//    }
//}
