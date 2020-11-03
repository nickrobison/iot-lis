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
            Divider()
            UserSettingsView(user: self.settings.user)
            Divider()
            LocationSettingsView(locationName: settings.locationName, zipCode: settings.zipCode)
            Spacer()
            Button("Logout user") {
                debugPrint("Logout pressed")
            }
            .accentColor(.red)
            
        }
        .padding([.leading, .bottom])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: ApplicationSettings(zipCode: "98103", locationName: "HHS", user: ApplicationUser(id: "1", firstName: "Test", lastName: "User", username: "testUser1")))
    }
}
