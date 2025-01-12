//
//  ICloudSettings.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Dependencies
import DependenciesAdditions

private enum ICloudUserDefaultsKey: DependencyKey {
    static let liveValue = UserDefaults.Dependency.ubiquitous
}

extension DependencyValues {
    public var iCloudUserDefaults: UserDefaults.Dependency {
        get { self[ICloudUserDefaultsKey.self] }
        set { self[ICloudUserDefaultsKey.self] = newValue }
    }
}

struct ICloudSettings {
    var bool: @Sendable (_ key: SettingsKey) -> Bool?
    var set: @Sendable (_ value: Bool?, _ forKey: SettingsKey) -> Void
}

extension ICloudSettings: DependencyKey {
    static var liveValue: Self {
        @Dependency(\.iCloudUserDefaults) var userDefaults
        return Self(bool: { key in
            userDefaults.bool(forKey: key.rawValue)
        }, set: { value, key in
            userDefaults.set(value, forKey: key.rawValue)
        })
    }
}

extension DependencyValues {
    var iCloudSettings: ICloudSettings {
        get { self[ICloudSettings.self] }
        set { self[ICloudSettings.self] = newValue }
    }
}
