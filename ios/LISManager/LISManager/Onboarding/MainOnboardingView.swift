//
//  MainOnboardingView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

enum OnboardingState : CaseIterable {
    case initial
    case location
}

struct MainOnboardingView: View {
    @State var onboardingState: OnboardingState = .initial
    @State private var stateIdx = 0
    
    var body: some View {
        VStack {
            Spacer()
            self.buildView()
        }
    }
    
    private func buildView() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            if (self.onboardingState == .initial) {
                InitialOnboardingView()
            } else if (self.onboardingState == .location) {
                LocationInformation()
            }
            Spacer()
            FullscreenButton(text: "Next", isAnimating: .constant(false), handler: {
                self.incrementState()
            })
        }
        .padding([.leading, .trailing, .bottom])
    }
    
    private func incrementState() -> Void {
        self.stateIdx += 1
        self.onboardingState = OnboardingState.allCases[self.stateIdx]
    }
}

struct MainOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        MainOnboardingView()
    }
}
