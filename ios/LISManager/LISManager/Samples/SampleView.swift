//
//  SampleListView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct SampleView: View {
    
    @FetchRequest(
        entity: SampleEntity.entity(),
        sortDescriptors: []
//        sortDescriptors: [
//            NSSortDescriptor(keyPath: \SampleEntity.cartridgeID, ascending: true)]
    )
    var samples: FetchedResults<SampleEntity>
    
    var body: some View {
        NavigationView {
            List(samples, id: \.cartridgeID) { sample in
                SampleCellView(sample: sample)
            }
        }
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
    
    
}
