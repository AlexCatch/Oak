//
//  Settings.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Resolver

enum SettingsKey: String {
    case requireAuthOnStart = "requireAuthOnStart"
    case biometricsEnabled = "biometricsEnabled"
}

struct Settings {
    func bool(key: SettingsKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    func set(key: SettingsKey, value: Any) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

extension Resolver {
    static func RegisterSettingsUtil() {
        register { Settings() }.scope(.shared)
    }
}
