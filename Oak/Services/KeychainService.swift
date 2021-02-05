//
//  AuthService.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import KeychainSwift
import Resolver

enum KeychainKeys: String {
    case password = "sh.catch.oak.Password"
}

protocol KeychainService {
    func set(key: KeychainKeys, value: String)
    func get(key: KeychainKeys) -> String?
}

class RealKeychainService: KeychainService {
    
    private let keychain = KeychainSwift()
    
    init() {
//        keychain.clear()
    }
    
    func set(key: KeychainKeys, value: String) {
        keychain.set(value, forKey: key.rawValue)
    }
    
    func get(key: KeychainKeys) -> String? {
        return keychain.get(key.rawValue)
    }
}

extension Resolver {
    public static func RegisterKeychainService() {
        register { RealKeychainService() as KeychainService }
    }
}
