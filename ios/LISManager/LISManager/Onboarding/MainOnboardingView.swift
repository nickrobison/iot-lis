//
//  MainOnboardingView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

struct MainOnboardingView: View {
    @ObservedObject var model: OnboardingModel

    var body: some View {
        VStack {
            Spacer()
            self.buildView()
        }
    }
    
    private func buildView() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            if self.model.onboardingState == .initial {
                InitialOnboardingView()
            } else if self.model.onboardingState == .location {
                LocationInformation(locationName: self.$model.locationName, zipCode: self.$model.zipCode)
            }
            Spacer()
            FullscreenButton(text: "Next", isAnimating: .constant(false), handler: {
                self.model.handleClick()
            })
            .disabled(self.model.buttonDisabled)
        }
        .padding([.leading, .trailing, .bottom])
    }
}

struct MainOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        MainOnboardingView(model: OnboardingModel(completionHandler: nil))
    }
}
