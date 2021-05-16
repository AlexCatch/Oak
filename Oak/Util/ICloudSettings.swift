//
//  ICloudSettings.swift
//  Oak
//
//  Created by Alex Catchpole on 15/05/2021.
//

import Foundation
import CloudKit
import Resolver

class ICloudSettings: RealSettings {
    override func bool(key: SettingsKey) -> Bool {
        return NSUbiquitousKeyValueStore.default.bool(forKey: key.rawValue)
    }
    
    override func set(key: SettingsKey, value: Any) {
        NSUbiquitousKeyValueStore.default.set(value, forKey: key.rawValue)
        NSUbiquitousKeyValueStore.default.synchronize()
    }
}

extension Resolver {
    static func RegisterICloudSettingsUtil() {
        register { ICloudSettings() }.scope(.shared)
    }
}
