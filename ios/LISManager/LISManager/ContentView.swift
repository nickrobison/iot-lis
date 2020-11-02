//
//  ContentView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var pm: PreferencesManager
    
    var body: some View {
        if (pm.settings == nil) {
            MainOnboardingView { s in
                pm.settings = s
            }
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
