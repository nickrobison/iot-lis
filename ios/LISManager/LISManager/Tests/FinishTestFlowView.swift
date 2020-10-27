//
//  FinishTestFlowView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI

struct FinishTestFlowView: View {
    
    @Binding var readNow: Bool
    @State private var wakeUp = Date()
    
    var body: some View {
        VStack {
            Text("Select test mode:")
            Toggle(isOn: $readNow, label: {
                Text("Read now?")
            }).padding()
            if readNow {
                buildTimerSetup()
            } else {
                EmptyView()
            }
            
        }
    }
    
    private func buildTimerSetup() -> some View {
        VStack {
            Text("Start timer")
            TimePicker(date: $wakeUp)
        }
    }
}

struct FinishTestFlowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FinishTestFlowView(readNow: .constant(true))
            FinishTestFlowView(readNow: .constant(false))
        }
    }
}
