//
//  AccountService.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import Resolver
import CoreData

struct CreateAccountData {
    var name = ""
    var issuer = ""
    var secret = ""
    var base32Encoded = true
    var type: CodeType = .totp
    var algorithm: Algorithm = .sha1
    var digits: Int = 6
    var period: Int?
    var counter: Int?
}

protocol AccountService {
    func save(parsedURI: ParsedURI) throws -> Account
    func save(data: CreateAccountData) throws -> Account
    func save(account: Account) throws
    func fetch() throws -> [Account]
    func delete(accounts: [Account]) throws
    func updateCounter(account: Account) throws -> Account?
}

class RealAccountService: AccountService {
    @Injected private var persistentStore: PersistentStore
    
    func fetch() throws -> [Account] {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        return try persistentStore.viewContext.fetch(fetchRequest)
    }
    
    @discardableResult
    func save(parsedURI: ParsedURI) throws -> Account {
        let account = Account(context: persistentStore.viewContext)
        account.issuer = parsedURI.issuer
        account.name = parsedURI.username
        account.secret = parsedURI.secret
        account.algorithm = parsedURI.algorithm
        account.type = parsedURI.type
        
        if let digits = Int16(parsedURI.digits) {
            account.digits = digits
        }
        
        if let period = parsedURI.period, let periodNum = Int16(period) {
            account.period = periodNum
        }

        if let counter = parsedURI.counter, let counterNum = Int16(counter) {
            account.counter = counterNum
        }
        
        try persistentStore.save()
        
        return account
    }
    
    func save(data: CreateAccountData) throws -> Account {
        let account = Account(context: persistentStore.viewContext)
        account.issuer = data.issuer
        account.name = data.name
        account.secret = data.secret
        account.algorithm = data.algorithm
        account.type = data.type
        account.digits = Int16(data.digits)
        
        
        if let period = data.period {
            account.period = Int16(period)
        }
        
        if let counter = data.counter {
            account.counter = Int16(counter)
        }
        
        try persistentStore.save()
        
        return account
    }
    
    func save(account: Account) throws {
        try persistentStore.viewContext.save()
    }
    
    func updateCounter(account: Account) throws -> Account? {
        account.counter = account.counter + 1
        try persistentStore.save()
        return account
    }
    
    func delete(accounts: [Account]) throws {
        for account in accounts {
            persistentStore.viewContext.delete(account)
        }
        try persistentStore.save()
    }
}

extension Resolver {
    public static func RegisterAccountService() {
        register { RealAccountService() as AccountService }
    }
}
