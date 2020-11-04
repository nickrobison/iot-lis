//
//  SampleScanView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI
import xxHash_Swift

struct SampleScanView: View {
    
    @Binding var sampleID: String
    @Binding var testFlowState: TestFlowModel.TestFlowState
    @Binding var stateIdx: Int
    
    var handler: (() -> Void)?
    
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
        let hashedID = XXH32.digestHex(msg)
        self.sampleID = hashedID
        self.handler?()
    }
}

struct SampleScanView_Previews: PreviewProvider {
    static var previews: some View {
        SampleScanView(sampleID: .constant("hello there"),
                       testFlowState: .constant(.sampleScan), stateIdx: .constant(1), handler: nil)
    }
}
