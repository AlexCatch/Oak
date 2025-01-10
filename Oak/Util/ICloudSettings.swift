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
    static var liveValue = UserDefaults.Dependency.ubiquitous
}

extension DependencyValues {
    public var iCloudUserDefaults: UserDefaults.Dependency {
        get { self[ICloudUserDefaultsKey.self] }
        set { self[ICloudUserDefaultsKey.self] = newValue }
    }
}

class ICloudSettings {
    @Dependency(\.iCloudUserDefaults) var userDefaults
    
    public func bool(forKey key: SettingsKey) -> Bool? {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    public func set(_ value: Bool?, forKey key: SettingsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
}

private enum ICloudSettingsDependencyKey: DependencyKey {
    static var liveValue = ICloudSettings()
}

extension DependencyValues {
    var iCloudSettings: ICloudSettings {
        get { self[ICloudSettingsDependencyKey.self] }
        set { self[ICloudSettingsDependencyKey.self] = newValue }
    }
}
