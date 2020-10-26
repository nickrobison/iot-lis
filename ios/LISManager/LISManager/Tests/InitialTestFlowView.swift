//
//  InitialTestFlowView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import SwiftUI

struct InitialTestFlowView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Let's begin...")
                .bold()
            Text("(time to test)")
        }
        .font(.title)
        
    }
}

struct InitialTestFlowView_Previews: PreviewProvider {
    static var previews: some View {
        InitialTestFlowView()
    }
}
