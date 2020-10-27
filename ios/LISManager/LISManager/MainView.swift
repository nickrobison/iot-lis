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
            SampleView()
                .tabItem {
                    VStack {
                        Image(systemName: "doc.text")
                        Text("Samples")
                    }
                }.tag(2)
            ResultsView()
                .tabItem {
                    VStack {
                        Image(systemName: "text.badge.checkmark")
                        Text("Results")
                    }
                }.tag(3)
            DevicesView()
                .tabItem {
                    VStack {
                        Image(systemName: "lightbulb")
                        Text("Devices")
                    }
                }.tag(4)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
