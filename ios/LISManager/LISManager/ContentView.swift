//
//  ContentView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var manager: PreferencesManager
    
    var body: some View {
        if manager.settings == nil {
            MainOnboardingView(model: OnboardingModel(completionHandler: { settings in
                manager.settings = settings
            }))
        } else {
            MainView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
