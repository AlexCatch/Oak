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

struct AccountDisplayable: Identifiable {
    var id: String
    var name: String
    var username: String?
}

class AccountsViewModel: ObservableObject {
    enum Sheet: Identifiable {
        case codeScanner
        case settings
        
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
    
    deinit {
        realmToken?.invalidate()
    }
    
    func fetchAccounts() {
        accounts = accountService.fetch()
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
    
    func addAccount(from uri: ParsedURI) {
        activeSheet = .none
        if let account = try? accountService.save(parsedURI: uri) {
            accountRowModels.append(AccountRowViewModel(account: account))
        }
    }
}

extension Resolver {
    static func RegisterAccountsViewModel() {
        register { AccountsViewModel() }
    }
}
