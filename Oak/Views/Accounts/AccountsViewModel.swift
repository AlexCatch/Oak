//
//  AccountsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import CodeScanner
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
    
    func fetchAccounts() {
        if let accounts = try? accountService.fetch() {
            self.accountRowModels = accounts.map { AccountRowViewModel(account: $0) }
        }
    }
    
    func navigate(to sheet: Sheet) {
        activeSheet = sheet
    }
    
    func didAddUpdateAccount(account: Account) {
        // Check to see if we're editing a selected account
        if let index = selectedAccountIndex {
            accountRowModels[index].account = account
            self.selectedAccountIndex = nil
            return
        }
        
        let vm = AccountRowViewModel(account: account)
        accountRowModels.append(vm)
    }
    
    func didDeleteAccount() {
        // We've deleted the selected index account
        guard let index = selectedAccountIndex else {
            return
        }
        accountRowModels.remove(at: index)
        selectedAccountIndex = nil
    }
    
    func editAccount(at index: Int) {
        self.selectedAccountIndex = index
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
