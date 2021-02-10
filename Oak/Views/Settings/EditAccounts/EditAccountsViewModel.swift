//
//  EditAccountsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import RealmSwift
import Resolver

class EditAccountsViewModel: ObservableObject {
    @Injected private var accountService: AccountService
    
    private var accountsForDeletion: IndexSet?
    private var accounts: Results<Account>?
    private var realmToken: NotificationToken?
    
    @Published var accountRowModels: [AccountRowViewModel] = []
    @Published var showingConfirmDeletionAlert = false
    
    deinit {
        realmToken?.invalidate()
    }
    
    func fetchAccounts() {
        // When our view model is initalised we'll setup our realm observer
        accounts = try? accountService.fetch()
        initializeRealmObserver()
    }
    
    /// Watch for changes to our accounts
    func initializeRealmObserver() {
        if let token = realmToken {
            token.invalidate()
        }
        
        realmToken = accounts?.observe { [weak self] (changes: RealmCollectionChange<Results<Account>>) in
            guard let self = self else {
                return
            }
            if let accounts = self.accounts {
                self.accountRowModels = accounts.map { AccountRowViewModel(account: $0) }
            }
        }
    }
    
    func deleteAccount(index: IndexSet) {
        if let accounts = accounts {
            let items = index.map({ accounts[$0] })
            try? accountService.delete(accounts: items)
        }
    }
}

extension Resolver {
    static func RegisterEditAccountsViewModel() {
        register { EditAccountsViewModel() }
    }
}
