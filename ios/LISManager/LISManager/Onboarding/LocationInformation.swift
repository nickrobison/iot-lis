//
//  LocationInformation.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI
import Combine

struct LocationInformation: View {
    @Binding var locationName: String
    @Binding var zipCode: String

    @ObservedObject var lm = LocationManager()
    
    var body: some View {
        VStack {
            Form {
                TextField("Location name", text: self.$locationName)
                TextField("Location Zip Code", text: self.$zipCode)
            }
        }
        .onAppear(perform: self.lm.requestLocation)
        .onReceive(self.lm.postalCode.replaceError(with: ""), perform: { val in
            debugPrint("Location val: \(val)")
            self.zipCode = val
        })
    }
}

struct LocationInformation_Previews: PreviewProvider {
    
    static var previews: some View {
        LocationInformation(locationName: .constant(""), zipCode: .constant(""))
    }
}
