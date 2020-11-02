//
//  MainOnboardingView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

enum OnboardingState: CaseIterable {
    case initial
    case location
}

struct MainOnboardingView: View {
    @State var onboardingState: OnboardingState = .initial
    @State var buttonDisabled = false
    @State private var stateIdx = 0
    
    var completionHandler: ((ApplicationSettings) -> Void)?
    
    var body: some View {
        VStack {
            Spacer()
            self.buildView()
        }
    }
    
    private func buildView() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            if self.onboardingState == .initial {
                InitialOnboardingView()
            } else if self.onboardingState == .location {
                LocationInformation(buttonDisabled: $buttonDisabled)
            }
            Spacer()
            FullscreenButton(text: "Next", isAnimating: .constant(false), handler: {
                self.handleClick()
            })
            .disabled(self.buttonDisabled)
        }
        .padding([.leading, .trailing, .bottom])
    }
    
    private func handleClick() {
        if (self.onboardingState == .location) {
            self.updateSettings()
        } else {
            self.incrementState()
        }
    }
    
    private func updateSettings() {
        let settings = ApplicationSettings(zipCode: "10293", locationName: "Test Location")
        self.completionHandler?(settings)
    }
    
    private func incrementState() {
        self.stateIdx += 1
        self.onboardingState = OnboardingState.allCases[self.stateIdx]
    }
}

struct MainOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        MainOnboardingView()
    }
}
