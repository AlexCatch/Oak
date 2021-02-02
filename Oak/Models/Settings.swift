//
//  Settings.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

enum SettingsKey: String {
    case requireAuthOnStart = "requireAuthOnStart"
    case biometricsEnabled = "biometricsEnabled"
}

struct Settings {
    static func bool(key: SettingsKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func set(key: SettingsKey, value: Any) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}
