//
//  ResultsAddView.swift
//  LISManager
//
//  Created by Nick Robison on 11/9/20.
//

import SwiftUI

struct ResultsAddView: View {
    @State var inferences: [Inference] = []
    
    var body: some View {
        ZStack {
            makeCamera()
            VStack {
                ForEach(self.inferences, id: \.self) { inference in
                    ResultCardView(testType: inference.className)
                }
            }
            .animation(.easeIn)
        }
    }
    
    private func makeCamera() -> some View {
        let controller = SampleScannerViewController()
        controller.handler = self.handleScan
        return controller
    }
    
    private func handleScan(inferences: [Inference]) {
        debugPrint("Pushing \(inferences.count) inferences")
        // This is where we need to determine if we already have the sample, or not
        self.inferences = inferences
    }
}

struct ResultsAddView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsAddView()
    }
}
