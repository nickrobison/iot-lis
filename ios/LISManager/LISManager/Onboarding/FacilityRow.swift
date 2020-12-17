//
//  FacilityRow.swift
//  LISManager
//
//  Created by Nick Robison on 12/17/20.
//

import SwiftUI
import SRKit

struct FacilityRow: View {
    
    let facility: SRFacility
    let selected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(facility.name).font(.headline)
                Text(facility.street).font(.subheadline)
            }
            Spacer()
            Image(systemName: "checkmark").foregroundColor(.green).opacity(self.selected ? 1.0 : 0.0)
        }
        .padding([.leading, .trailing])
        
    }
}

struct FacilityRow_Previews: PreviewProvider {
    static var previews: some View {
        FacilityRow(facility: SRFacility(id: UUID(), name: "Test Facility", street: "1234 Sesame Street"), selected: true)
    }
}
