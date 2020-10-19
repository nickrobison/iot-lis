//
//  MainView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import SwiftUI

struct MainView: View {
    
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            Text("Tab Content 1")
                .tabItem { Text("Home") }.tag(0)
            DevicesView(devices: [])
                .tabItem { Text("Devices") }.tag(1)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
