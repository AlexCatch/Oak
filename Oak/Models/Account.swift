//
//  Account.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import Foundation
import RealmSwift

class Account: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var issuer: String = ""
    @objc dynamic var username: String?
    @objc dynamic var usesBase32 = true
    @objc dynamic var secret: String = ""
    @objc dynamic var algorithmRaw: String = ""
    @objc dynamic var typeRaw: String = ""
    @objc dynamic var digits: Int = 6
    @objc dynamic var timestamp = Date()

    let period = RealmOptional<Int>()
    let counter = RealmOptional<Int>()
    
    var algorithm: Algorithm {
        set {
            algorithmRaw = newValue.rawValue
        }
        get {
            // litterally cannot go tits up
            return Algorithm(rawValue: algorithmRaw)!
        }
    }
    
    var type: CodeType {
        set {
            typeRaw = newValue.rawValue
        }
        get {
            // litterally cannot go tits up
            return CodeType(rawValue: typeRaw)!
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Account {
    static func Create(issuer: String, username: String?, usesBase32: Bool = true, secret: String, algorithm: Algorithm, type: CodeType, digits: Int, period: Int? = nil, counter: Int? = nil) -> Account {
        let account = Account()
        account.issuer = issuer
        account.username = username
        account.secret = secret
        account.algorithm = algorithm
        account.type = type
        account.digits = digits
        account.period.value = period
        account.counter.value = period
        return account
    }
}
