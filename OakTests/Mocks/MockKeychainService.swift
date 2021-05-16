//
//  MockKeychainService.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import Foundation
@testable import Oak

class MockKeychainService: KeychainService {
    var items: Dictionary<KeychainKeys, String> = [:]
    
    func set(key: KeychainKeys, value: String) {
        items[key] = value
    }
    
    func get(key: KeychainKeys) -> String? {
        return items[key]
    }
}
