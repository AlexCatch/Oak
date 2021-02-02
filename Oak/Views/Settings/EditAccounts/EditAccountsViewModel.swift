//
//  EditAccountsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import RealmSwift

class EditAccountsViewModel: ObservableObject {
    private let accountService: AccountService
    private var accountsForDeletion: IndexSet?
    private var accounts: Results<Account>
    private var realmToken: NotificationToken?
    
    @Published var accountRowModels: [AccountRowViewModel] = []
    @Published var showingConfirmDeletionAlert = false
    
    init(accountService: AccountService) {
        self.accountService = accountService
        
        // When our view model is initalised we'll setup our realm observer
        accounts = accountService.fetch()
        initializeRealmObserver()
    }
    
    deinit {
        realmToken?.invalidate()
    }
    
    /// Watch for changes to our accounts
    func initializeRealmObserver() {
        realmToken = accounts.observe { [weak self] (changes: RealmCollectionChange<Results<Account>>) in
            guard let self = self else {
                return
            }
            self.accountRowModels = self.accounts.map { AccountRowViewModel(account: $0) }
        }
    }
    
    func deleteAccount(index: IndexSet) {
        let items = index.map({ accounts[$0] })
        try? accountService.delete(accounts: items)
    }
}
