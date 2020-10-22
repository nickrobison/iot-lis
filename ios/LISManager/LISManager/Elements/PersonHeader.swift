//
//  PersonHeader.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct PersonHeader: View {
    let name: PersonNameComponents
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                InitialsView(name: name)
                VStack(alignment: .leading) {
                    Text(getLastName()).font(.title)
                    Text(getFirstName()).font(.callout)
                }
                Spacer()
            }
        }
        .padding([.leading])
    }
    
    private func getLastName() -> String {
        self.name.familyName ?? ""
    }
    
    private func getFirstName() -> String {
        self.name.givenName ?? ""
    }
}

struct PersonHeader_Previews: PreviewProvider {
    static var previews: some View {
        PersonHeader(name: PersonNameComponentsFormatter().personNameComponents(from: "Nicholas Robison")!)
    }
}
