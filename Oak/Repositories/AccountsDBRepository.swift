//
//  AccountsDBRepository.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import RealmSwift

protocol AccountsDBRepository {
    func save(account: Account) throws
    func fetch() -> Results<Account>
    func delete(accounts: [Account]) throws
}

class RealAccountsDBRepository: AccountsDBRepository {
    private let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func save(account: Account) throws {
        try realm.write {
            realm.add(account)
        }
    }
    
    func fetch() -> Results<Account> {
        return realm.objects(Account.self).sorted(byKeyPath: "timestamp", ascending: false)
    }
    
    func delete(accounts: [Account]) throws {
        try realm.write {
            realm.delete(accounts)
        }
    }
}
