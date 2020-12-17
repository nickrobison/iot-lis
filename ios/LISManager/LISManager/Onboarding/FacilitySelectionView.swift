//
//  FacilitySelectionView.swift
//  LISManager
//
//  Created by Nick Robison on 12/17/20.
//

import SwiftUI
import SRKit

struct FacilitySelectionView: View {
    
    var facilities: [SRFacility]
    @Binding var selectedFacility: UUID?
    
    var body: some View {
        Spacer()
        HStack {
            Text("Select facility:").font(.callout)
            Spacer()
        }.padding([.leading])
        ForEach(self.facilities) { facility in
            FacilityRow(facility: facility, selected: self.selectedFacility == facility.id).onTapGesture(perform: {
                // If we're already selected, deselect
                if self.selectedFacility == facility.id {
                    self.selectedFacility = nil
                } else {
                    self.selectedFacility = facility.id
                }
            })
        }
        Spacer()
    }
}

struct FacilitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FacilitySelectionView(facilities: [
            SRFacility(id: UUID(), name: "Test Facility", street: "123 Main Street"),
            SRFacility(id: UUID(), name: "New Facility", street: "123 Sesame Street")
        ], selectedFacility: .constant(UUID()))
    }
}
