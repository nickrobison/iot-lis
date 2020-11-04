//
//  LocationSettingsView.swift
//  LISManager
//
//  Created by Nick Robison on 11/3/20.
//

import SwiftUI

struct LocationSettingsView: View {
    
    let locationName: String
    let zipCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Location").font(.headline)
            Divider()
            Text("Location Name: \(locationName)")
            Text("Zip: \(zipCode)")
        }
    }
}

struct LocationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSettingsView(locationName: "HHS", zipCode: "95102")
    }
}
