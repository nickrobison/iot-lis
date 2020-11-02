//
//  NameCard.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct InitialsView: View {
    
    let name: PersonNameComponents
    var body: some View {
        Text("\(firstLetter(name.givenName))\(firstLetter(name.familyName))")
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .padding()
            .background(Circle()
                            .fill(Color.gray)
                            .clipped())
    }
    
    private func firstLetter(_ str: String?) -> String {
        guard let val = str?.first else {
            return ""
        }
        
        return String(val)
    }
}

struct InitialsView_Previews: PreviewProvider {
    static var previews: some View {
        InitialsView(name: PersonNameComponentsFormatter().personNameComponents(from: "Nick Robison")!)
    }
}
