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
class Account: Equatable, Identifiable {
    var algorithmRaw: String?
    var counter: Int = 0
    var createdAt: Date = Date()
    var digits: Int = 6
    var issuer: String?
    var name: String?
    var order: Int = 0
    var period: Int = 30
    var secret: String?
    var typeRaw: String?
    var usesBase32: Bool = true
    
    init(algorithmRaw: String, counter: Int = 0, createdAt: Date = Date(), digits: Int = 6, issuer: String, name: String?, order: Int = 0, period: Int = 30, secret: String, typeRaw: String, usesBase32: Bool = true) {
        self.algorithmRaw = algorithmRaw
        self.counter = counter
        self.createdAt = createdAt
        self.digits = digits
        self.issuer = issuer
        self.name = name
        self.order = order
        self.period = period
        self.secret = secret
        self.typeRaw = typeRaw
        self.usesBase32 = usesBase32
    }
    
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

extension Account {
    nonisolated(unsafe) static let mock = Account(algorithmRaw: Algorithm.sha256.rawValue, counter: 0, createdAt: Date(), digits: 6, issuer: "Oak", name: "Google", order: 0, period: 30, secret: "hello", typeRaw: CodeType.totp.rawValue, usesBase32: true)
}
