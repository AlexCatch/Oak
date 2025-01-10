//
//  AuthService.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
@preconcurrency import KeychainSwift
import Dependencies

enum KeychainKeys: String {
    case password = "sh.catch.oak.Password"
}

struct KeychainService {
    var set: @Sendable (_ key: KeychainKeys, _ value: String) -> Void
    var get: @Sendable (_ key: KeychainKeys) -> String?
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
    
    static var previewValue: Self {
        let storage = LockIsolated([String: String]())
        return Self { key, value in
            storage.withValue {
                $0[key.rawValue] = value
            }
        } get: { key in
            storage.value[key.rawValue]
        }
    }
    
    static var testValue: Self {
        return .previewValue
    }
}

extension DependencyValues {
    var keychainService: KeychainService {
        get { self[KeychainService.self] }
        set { self[KeychainService.self] = newValue }
  }
}

