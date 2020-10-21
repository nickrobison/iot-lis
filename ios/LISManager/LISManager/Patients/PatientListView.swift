//
//  PatientListView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/21/20.
//

import SwiftUI

struct PatientListView: View {
    var body: some View {
        CameraViewController()
            .edgesIgnoringSafeArea(.top)
        //        VStack{
        //            Text("Hello patients")
        //            Button("Scan something") {
        //
        //            }
        //        }
    }
}

struct PatientListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientListView()
    }
}
