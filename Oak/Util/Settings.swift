//
//  Settings.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Dependencies
import DependenciesAdditions

enum SettingsKey: String {
    case failedToDeleteZone = "failedToDeleteZone"
    case iCloudEnabled = "iCloudEnabled"
    case requireAuthOnStart = "requireAuthOnStart"
    case biometricsEnabled = "biometricsEnabled"
    case isSetup = "isSetup"
}

struct Settings {
    @Dependency(\.userDefaults) var userDefaults
    
    public func bool(forKey key: SettingsKey) -> Bool? {
        return userDefaults.bool(forKey: key.rawValue)
    }

    public func set(_ value: Bool?, forKey key: SettingsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
}

extension Settings: DependencyKey {
    static var liveValue: Self {
        return self.init()
    }
    static var previewValue: Self {
        return .liveValue
    }
    static var testValue: Self {
        return .liveValue
    }
}

extension DependencyValues {
    var settings: Settings {
        get { self[Settings.self] }
        set { self[Settings.self] = newValue }
    }
}
