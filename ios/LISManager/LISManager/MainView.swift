//
//  MainView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import SwiftUI
import LISKit
import Combine

struct MainView: View {
    
    @EnvironmentObject var bm: BluetoothManager
    
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            Text("Tab Content 1")
                .tabItem {
                    VStack{
                        Image(systemName: "house")
                        Text("Home")
                    }
                }.tag(0)
            
            PatientListView()
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.stack.person.crop.fill")
                        Text("Patients")
                    }
                }.tag(1)
            ResultsView(model: ResultsViewModel(publisher: bm.resultsSubject.eraseToAnyPublisher()))
                .tabItem {
                    VStack {
                        Image(systemName: "text.badge.checkmark")
                        Text("Results")
                    }
                }.tag(2)
            DevicesView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Devices")
                    }
                }.tag(3)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
