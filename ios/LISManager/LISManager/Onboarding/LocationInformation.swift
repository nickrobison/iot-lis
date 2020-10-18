//
//  LocationInformation.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

struct LocationInformation: View {
    
    @ObservedObject private var lm = LocationManager()
    
    var body: some View {
        VStack {
            Text("Location time")
            Text(lm.county ?? "")
        }
        
    }
}

struct LocationInformation_Previews: PreviewProvider {
    static var previews: some View {
        LocationInformation()
    }
}
