//
//  PreferencesManager.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import Foundation

class PreferencesManager: ObservableObject {
    static let SettingsKey = "ApplicationSettings"
    
    @Published var settings: ApplicationSettings? {
        willSet(newSettings) {
            self.saveSettings(newSettings)
        }
    }
    
    init() {
        self.settings = loadSettings()
    }
    
    private func loadSettings() -> ApplicationSettings? {
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.data(forKey: PreferencesManager.SettingsKey) {
            let decoder = JSONDecoder()
            return try? decoder.decode(ApplicationSettings.self, from: savedSettings)
        }
        
        return nil
    }
    
    private func saveSettings(_ settings: ApplicationSettings?) {
        guard let settings = settings else {
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: PreferencesManager.SettingsKey)
        }
    }
}

struct ApplicationSettings: Codable {
    var zipCode: String
    var locationName: String
}
