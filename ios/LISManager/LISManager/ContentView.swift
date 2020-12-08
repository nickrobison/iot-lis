//
//  ContentView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI
import SRKit

struct SRBackendKey: EnvironmentKey {
    typealias Value = SRBackend
    static var defaultValue: Value = SRNoOtpBackend()
}

extension EnvironmentValues {
    var srBackend: SRBackend {
        get {
            return self[SRBackendKey.self]
        }
        set {
            self[SRBackendKey.self] = newValue
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var manager: PreferencesManager
    @Environment(\.managedObjectContext) var ctx
    
    var body: some View {
        Group {
            if manager.settings == nil {
                MainOnboardingView(model: OnboardingModel(completionHandler: { settings in
                    self.manager.settings = settings
                }))
            } else {
                MainView()
                    .environment(\.srBackend, SRHttpBackend(connect: "http://172.20.10.2:8080/graphql"))
                    .environmentObject(SRMonitor(ctx: ctx, backend: SRHttpBackend(connect: "http://172.20.10.2:8080/graphql")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
