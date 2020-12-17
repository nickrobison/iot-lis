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
            } else if self.model.onboardingState == .user {
                UserLoginView(user: self.$model.user)
            } else if self.model.onboardingState == .location {
                buildFacilityView()
            }
            Spacer()
            FullscreenButton(text: "Next", isAnimating: .constant(false), handler: {
                self.model.handleClick()
            })
            .disabled(self.model.buttonDisabled)
        }
        .padding([.leading, .trailing, .bottom])
    }
    
    private func buildFacilityView() -> some View {
        FacilitySelectionView(facilities: self.model.facilities, selectedFacility: self.$model.selectedFacilityID)
            .onAppear {
                // This, of course, has to go away
                self.model.fetchFacilities(connect: "http://127.0.0.1:8080/graphql", for: self.model.user!.organizationID)
            }
    }
}

struct MainOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        MainOnboardingView(model: OnboardingModel(completionHandler: nil))
    }
}
