//
//  AccountsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import CodeScanner
import Resolver
import CoreData

class AccountsViewModel: NSObject, AccountServiceDelegate, ObservableObject {
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
    @Injected private var persistentStore: PersistentStore

    @Published var accountRowModels: [AccountRowViewModel] = []
    @Published var activeSheet: Sheet?
    @Published var activeActionSheet: ActionSheet?
    
    @Published var searchText: String = ""
    
    // Account we're currently editing - used from list context menu
    var selectedAccountIndex: Int?
    var selectedAccount: Account? {
        guard let selectedIndex = selectedAccountIndex else {
            return nil
        }
        
        guard selectedIndex < accountRowModels.count else {
            // index doesn't exist in array
            return nil
        }
        
        return accountRowModels[selectedIndex].account
    }
    
    override init() {
        super.init()
        accountService.delegate = self
    }
    
    func navigate(to sheet: Sheet) {
        activeSheet = sheet
    }
    
    func performQuery(text: String) {
        let predicate = text.trimmed().isEmpty ? nil : NSPredicate(format: "name CONTAINS[cd] %@ OR issuer CONTAINS[cd] %@", text, text)
        try? accountService.filter(predicate: predicate)
    }
    
    func editAccount(account: Account) {
        if let index = accountRowModels.firstIndex(where: { $0.account.id == account.id }) {
            self.selectedAccountIndex = index
        }
        navigate(to: .newAccount)
    }
    
    func hideSheet() {
        activeSheet = nil
    }
    
    func accountsChanged(accounts: [Account]) {
        accountRowModels = accounts.map {  AccountRowViewModel(account: $0) }
    }
}

extension Resolver {
    static func RegisterAccountsViewModel() {
        register { AccountsViewModel() }
    }
}
