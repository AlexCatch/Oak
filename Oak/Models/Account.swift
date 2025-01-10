//
//  Account.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import Foundation
import CoreData
import SwiftOTP
import SwiftData

@Model
class Account {
    var algorithmRaw: String?
    var counter: Int = 0
    var createdAt: Date = Date()
    var digits: Int = 6
    var issuer: String?
    var name: String?
    var order: Int = 0
    var period: Int = 30
    @Attribute(.allowsCloudEncryption) var secret: String?
    var typeRaw: String?
    var usesBase32: Bool = true
    
    init() {}
    
    var algorithm: Algorithm {
        set {
            algorithmRaw = newValue.rawValue
        }
        get {
            guard let rawAlgo = algorithmRaw else {
                return .sha1
            }
            // litterally cannot go tits up
            return Algorithm(rawValue: rawAlgo) ?? .sha1
        }
    }
    
    var type: CodeType? {
        set {
            typeRaw = newValue?.rawValue
        }
        get {
            guard let rawType = typeRaw else {
                return nil
            }
            // litterally cannot go tits up
            return CodeType(rawValue: rawType)!
        }
    }
    
    func decodeSecret() -> Data? {
        guard let secret = secret else {
            return nil
        }
        
        if usesBase32 {
            return base32DecodeToData(secret) ?? secret.data(using: .utf8)
        }
        
        return secret.data(using: .utf8)
    }
}
