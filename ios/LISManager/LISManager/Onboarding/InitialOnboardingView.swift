//
//  InitialOnboardingView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

struct InitialOnboardingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Hello,")
                    .bold()
                Text("Let's get started")
            }
        }
        .font(.title)
    }
}

struct InitialOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        InitialOnboardingView()
    }
}
