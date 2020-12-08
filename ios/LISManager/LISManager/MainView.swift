//
//  MainView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import SwiftUI
import LISKit
import Combine

enum MainTabView: CaseIterable {
    case home
    case patients
    case orders
    case results
    case devices
    case settings
    
}

struct MainView: View {
    
    @EnvironmentObject var pm: PreferencesManager
    @Environment(\.srBackend) var backend
    @Environment(\.managedObjectContext) var ctx
    @State private var selection: MainTabView = .home
    
    var body: some View {
        TabView(selection: $selection) {
            Text("Tab Content 1")
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }.tag(MainTabView.home)
            
            PatientListView()
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.stack.person.crop.fill")
                        Text("Patients")
                    }
                }.tag(MainTabView.patients)
            OrderView()
                .tabItem {
                    VStack {
                        Image(systemName: "doc.text")
                        Text("Orders")
                    }
                }.tag(MainTabView.orders)
            ResultsView()
                .tabItem {
                    VStack {
                        Image(systemName: "text.badge.checkmark")
                        Text("Results")
                    }
                }.tag(MainTabView.results)
            DevicesView()
                .tabItem {
                    VStack {
                        Image(systemName: "lightbulb")
                        Text("Devices")
                    }
                }.tag(MainTabView.devices)
            SettingsView(settings: pm.settings!)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }.tag(MainTabView.settings)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
