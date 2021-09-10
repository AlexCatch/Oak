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
    @Published var isDeleting = false
    
    var accountRowToDelete: AccountRowViewModel?
    var accountRowToDeleteIndex: Int?
    
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
    
    func move(source: IndexSet, destination: Int) {
        accountRowModels.move(fromOffsets: source, toOffset: destination)
        for (index, viewModel) in accountRowModels.enumerated() {
            viewModel.account.order = Int16(index)
            try? accountService.save()
        }
    }
    
    func delete(at index: IndexSet) {
        guard let accountIndex = index.first else {
            return
        }
        
        // Remove locally from our data store, if the user cancels we can just refetch
        accountRowToDelete = accountRowModels[accountIndex]
        accountRowToDeleteIndex = accountIndex
        isDeleting = true
        
        accountRowModels.remove(at: accountIndex)
    }
    
    func confirmDeletion() {
        guard let accountRow = accountRowToDelete else {
            return
        }
        
        try? accountService.delete(accounts: [accountRow.account])
        
        isDeleting = false
        accountRowToDeleteIndex = nil
        accountRowToDelete = nil
    }
    
    func cancelDeletion() {
        guard let accountIndex = accountRowToDeleteIndex, let account = accountRowToDelete else {
            return
        }
        
        // Reinsert our item into our list
        withAnimation(.spring()) {
            accountRowModels.insert(account, at: accountIndex)
            
            accountRowToDelete = nil
            accountRowToDeleteIndex = nil
            isDeleting = false
        }
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
