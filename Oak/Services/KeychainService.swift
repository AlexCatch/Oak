//
//  AuthService.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import KeychainSwift
import Dependencies

enum KeychainKeys: String {
    case password = "sh.catch.oak.Password"
}

struct KeychainService {
    var set: (_ key: KeychainKeys, _ value: String) -> Void
    var get: (_ key: KeychainKeys) -> String?
}

extension KeychainService: DependencyKey {
    static var liveValue: Self {
        let keychain = KeychainSwift()
        return Self { key, value in
            keychain.set(value, forKey: key.rawValue)
        } get: { key in
            return keychain.get(key.rawValue)
        }
    }
    static var previewValue = liveValue
}

extension DependencyValues {
    var keychainService: KeychainService {
        get { self[KeychainService.self] }
        set { self[KeychainService.self] = newValue }
  }
}

