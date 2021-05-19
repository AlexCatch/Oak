//
//  MockSettings.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import Foundation
@testable import OakOTP

class MockSettings: Settings {
    private var settings: Dictionary<SettingsKey, Any> = [:]
    
    func bool(key: SettingsKey) -> Bool {
        return settings[key] as? Bool ?? false
    }
    
    func set(key: SettingsKey, value: Any) {
        settings[key] = value
    }
}
