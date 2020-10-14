//
//  iot_lis_clientApp.swift
//  iot-lis-client
//
//  Created by Nicholas Robison on 10/13/20.
//

import SwiftUI

@main
struct iot_lis_clientApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
