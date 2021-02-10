//
//  AccountService.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import RealmSwift
import Resolver

struct CreateAccountData {
    var name = ""
    var issuer = ""
    var secret = ""
    var base32Encoded = true
    var type: CodeType = .totp
    var algorithm: Algorithm = .sha1
    var digits: Int = 6
    var period: Int?
}

protocol AccountService {
    func save(parsedURI: ParsedURI) throws -> Account
    func save(data: CreateAccountData) throws -> Account
    func fetch() throws -> Results<Account>
    func delete(accounts: [Account]) throws
    func updateCounter(account: Account) throws -> Account?
}

class RealAccountService: AccountService {
    @Injected private var dbRepository: AccountsDBRepository
    
    func fetch() throws -> Results<Account> {
        return try dbRepository.fetch()
    }
    
    @discardableResult
    func save(parsedURI: ParsedURI) throws -> Account {
        
        let account = Account.Create(issuer: parsedURI.issuer, username: parsedURI.username, secret: parsedURI.secret, algorithm: parsedURI.algorithm, type: parsedURI.type, digits: Int(parsedURI.digits) ?? 6)
        
        if let period = parsedURI.period, let periodNum = Int(period) {
            account.period.value = periodNum
        }
        
        if let counter = parsedURI.counter, let counterNum = Int(counter) {
            account.counter.value = counterNum
        }
        
        try dbRepository.save(account: account)
        
        return account
    }
    
    @discardableResult
    func save(data: CreateAccountData) throws -> Account {
        let account = Account.Create(issuer: data.issuer, username: data.name, usesBase32: data.base32Encoded, secret: data.secret, algorithm: data.algorithm, type: data.type, digits: data.digits, period: data.period, counter: data.type == .hotp ? 0 : nil)
        try dbRepository.save(account: account)
        return account
    }
    
    func updateCounter(account: Account) throws -> Account? {
        guard account.type == .hotp else {
            return nil
        }
        
        // account will be frozen, refetch for ID and increment
        if let refetchedAccount = try? dbRepository.fetch(for: account.id) {
            try dbRepository.performUpdate {
                refetchedAccount.counter.value? += 1
            }
            return refetchedAccount.freeze()
        }
        return account
    }
    
    func delete(accounts: [Account]) throws {
        try dbRepository.delete(accounts: accounts)
    }
}

extension Resolver {
    public static func RegisterAccountService() {
        register { RealAccountService() as AccountService }
    }
}
