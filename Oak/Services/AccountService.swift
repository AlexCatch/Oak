//
//  AccountService.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import RealmSwift
import Resolver

protocol AccountService {
    func save(parsedURI: ParsedURI) throws -> Account
    func fetch() -> Results<Account>
    func delete(accounts: [Account]) throws
}

class RealAccountService: AccountService {
    private let dbRepository: AccountsDBRepository
    
    init(dbRepository: AccountsDBRepository) {
        self.dbRepository = dbRepository
    }
    
    func fetch() -> Results<Account> {
        return dbRepository.fetch()
    }
    
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
    
    func delete(accounts: [Account]) throws {
        try dbRepository.delete(accounts: accounts)
    }
}

extension Resolver {
    public static func RegisterAccountService() {
        register { RealAccountService(dbRepository: resolve()) as AccountService }
    }
}
