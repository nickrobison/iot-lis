//
//  ResultsAddView.swift
//  LISManager
//
//  Created by Nick Robison on 11/9/20.
//

import SwiftUI

struct ResultsAddView: View {
    var body: some View {
        makeCamera()
    }
    
    private func makeCamera() -> some View {
        let controller = SampleScannerViewController()
        controller.handler = self.handleScan
        return controller
    }
    
    private func handleScan(inferences: [Inference]) {
        
    }
}

struct ResultsAddView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsAddView()
    }
}
