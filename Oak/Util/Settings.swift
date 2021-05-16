//
//  Settings.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Resolver

enum SettingsKey: String {
    case failedToDeleteZone = "failedToDeleteZone"
    case iCloudEnabled = "iCloudEnabled"
    case requireAuthOnStart = "requireAuthOnStart"
    case biometricsEnabled = "biometricsEnabled"
    case isSetup = "isSetup"
}

protocol Settings {
    func bool(key: SettingsKey) -> Bool
    func set(key: SettingsKey, value: Any)
}

class RealSettings: Settings {
    func bool(key: SettingsKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    func set(key: SettingsKey, value: Any) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

extension Resolver {
    static func RegisterSettingsUtil() {
        register { RealSettings() as Settings }.scope(.shared)
    }
}
