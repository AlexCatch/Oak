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
    var delegate: AccountServiceDelegate? { get set }
    func filter(predicate: NSPredicate?) throws
    func fetchAll() -> [Account]
    func save(parsedURI: ParsedURI) throws
    func save(data: CreateAccountData) throws
    func save() throws
    func delete(accounts: [Account]) throws
    func updateCounter(account: Account) throws -> Account
}

protocol AccountServiceDelegate: AnyObject {
    func accountsChanged(accounts: [Account])
}

class RealAccountService: NSObject, NSFetchedResultsControllerDelegate, AccountService {
    
    static let DefaultSortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
    
    weak var delegate: AccountServiceDelegate? {
        didSet {
            // When our delegate is set - send our initial accounts
            if let accounts = accountsDataController?.fetchedObjects {
                delegate?.accountsChanged(accounts: accounts)
            }
        }
    }
    
    @Injected public var persistentStore: PersistentStore
    private var accountsDataController: NSFetchedResultsController<Account>?
    
    override init() {
        super.init()
        
        accountsDataController = Account.resultsController(context: persistentStore.viewContext, request: Account.fetchRequest(), sortDescriptors: RealAccountService.DefaultSortDescriptors)
        accountsDataController?.delegate = self
        
        // do an initial fetch
        try? accountsDataController?.performFetch()
    }
    
    func fetchAll() -> [Account] {
        try? accountsDataController?.performFetch()
        return accountsDataController?.fetchedObjects ?? []
    }
    
    func filter(predicate: NSPredicate?) throws {
        if let predicate = predicate {
            accountsDataController?.fetchRequest.predicate = predicate
            accountsDataController?.fetchRequest.sortDescriptors = RealAccountService.DefaultSortDescriptors
        } else {
            accountsDataController?.fetchRequest.predicate = nil
        }
        
        try accountsDataController?.performFetch()
        
        if let accounts = accountsDataController?.fetchedObjects {
            delegate?.accountsChanged(accounts: accounts)
        }
    }

    func save(parsedURI: ParsedURI) throws {
        let account = Account(context: persistentStore.viewContext)
        account.issuer = parsedURI.issuer
        account.name = parsedURI.username
        account.secret = parsedURI.secret
        account.algorithm = parsedURI.algorithm
        account.type = parsedURI.type
        account.createdAt = Date()
        
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
    }
    
    func save(data: CreateAccountData) throws {
        let account = Account(context: persistentStore.viewContext)
        account.issuer = data.issuer
        account.name = data.name
        account.secret = data.secret
        account.usesBase32 = data.base32Encoded
        account.algorithm = data.algorithm
        account.type = data.type
        account.digits = Int16(data.digits)
        account.createdAt = Date()
        
        
        if let period = data.period {
            account.period = Int16(period)
        }
        
        if let counter = data.counter {
            account.counter = Int16(counter)
        }
        
        try persistentStore.save()
    }
    
    func save() throws {
        try persistentStore.viewContext.save()
    }
    
    func updateCounter(account: Account) throws -> Account {
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedAccounts = controller.fetchedObjects as? [Account] {
            delegate?.accountsChanged(accounts: fetchedAccounts)
        }
    }
}

extension Resolver {
    public static func RegisterAccountService() {
        register { RealAccountService() as AccountService }
    }
}
