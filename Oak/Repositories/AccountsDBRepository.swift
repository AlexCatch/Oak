//
//  AccountsDBRepository.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import RealmSwift
import Resolver

protocol AccountsDBRepository {
    func save(account: Account) throws
    func fetch() throws -> Results<Account>
    func fetch(for primaryKey: String) throws -> Account?
    func delete(accounts: [Account]) throws
    func performUpdate(callback: () -> Void) throws
}

class RealAccountsDBRepository: AccountsDBRepository {
    
    func save(account: Account) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(account)
        }
    }
    
    func fetch() throws -> Results<Account> {
        let realm = try Realm()
        return realm.objects(Account.self).sorted(byKeyPath: "timestamp", ascending: false)
    }
    
    func fetch(for primaryKey: String) throws -> Account? {
        let realm = try Realm()
        return realm.object(ofType: Account.self, forPrimaryKey: primaryKey)
    }
    
    func delete(accounts: [Account]) throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(accounts)
        }
    }
    
    func performUpdate(callback: () -> Void) throws {
        let realm = try! Realm()
        try! realm.write(callback)
    }
}

extension Resolver {
    public static func RegisterAccountDBRepository() {
        register {  RealAccountsDBRepository() as AccountsDBRepository }
    }
}
