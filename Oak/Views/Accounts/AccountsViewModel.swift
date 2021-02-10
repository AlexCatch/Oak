//
//  AccountsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import CodeScanner
import RealmSwift
import Resolver

class AccountsViewModel: ObservableObject {
    enum Sheet: Identifiable {
        case codeScanner
        case settings
        case newAccount
        
        var id: Int {
            hashValue
        }
    }

    enum ActionSheet: Identifiable {
        case add
        
        var id: Int {
            hashValue
        }
    }
    
    @Injected private var accountService: AccountService

    @Published var accountRowModels: [AccountRowViewModel] = []
    @Published var activeSheet: Sheet?
    @Published var activeActionSheet: ActionSheet?
    
    private var realmToken: NotificationToken?
    private var accounts: Results<Account>?
    
    // Account we're currently editing - used from list context menu
    var editingAccount: Account?
    
    deinit {
        realmToken?.invalidate()
    }
    
    func fetchAccounts() {
        accounts = try? accountService.fetch()
        initializeRealmObserver()
    }
    
    /// Watch for changes to our accounts
    func initializeRealmObserver() {
        if let token = realmToken {
            token.invalidate()
        }

        realmToken = accounts?.observe { [weak self] (changes: RealmCollectionChange<Results<Account>>) in
            if let accounts = self?.accounts {
                self?.accountRowModels = accounts.map { AccountRowViewModel(account: $0) }
            }
        }
    }
    
    func navigate(to sheet: Sheet) {
        activeSheet = sheet
    }
    
    func editAccount(account: Account) {
        self.editingAccount = account
        navigate(to: .newAccount)
    }
    
    func hideSheet() {
        activeSheet = nil
    }
}

extension Resolver {
    static func RegisterAccountsViewModel() {
        register { AccountsViewModel() }
    }
}
