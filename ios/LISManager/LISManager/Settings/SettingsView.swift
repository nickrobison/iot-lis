//
//  SettingsView.swift
//  LISManager
//
//  Created by Nick Robison on 11/2/20.
//

import SwiftUI

struct SettingsView: View {
    
    var settings: ApplicationSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings").font(.title)
            Spacer()
            Text("Location").font(.headline)
            Divider()
            Text("Location: \(settings.locationName)")
            Text("Zip: \(settings.zipCode)")
            Spacer()
        }
        .padding([.leading])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: ApplicationSettings(zipCode: "98103", locationName: "HHS"))
    }
}
