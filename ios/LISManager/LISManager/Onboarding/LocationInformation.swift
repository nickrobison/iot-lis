//
//  LocationInformation.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI
import Combine

struct LocationInformation: View {
    @Binding var buttonDisabled: Bool
    @ObservedObject var model = LocationInformationViewModel()
    
    var body: some View {
        VStack {
            Form {
                TextField("Location name", text: $model.locationName)
                TextField("Location Zip Code", text: $model.locationPostalCode)
            }
        }
    }
}

struct LocationInformation_Previews: PreviewProvider {
    
    static var previews: some View {
        LocationInformation(buttonDisabled: .constant(true))
    }
}
