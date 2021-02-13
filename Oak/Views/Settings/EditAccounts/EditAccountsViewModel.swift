//
//  EditAccountsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import Resolver

class EditAccountsViewModel: ObservableObject {
    @Injected private var accountService: AccountService
    
    private var accountsForDeletion: IndexSet?
    private var accounts: [Account]?
    
    @Published var accountRowModels: [AccountRowViewModel] = []
    @Published var showingConfirmDeletionAlert = false
    
    func fetchAccounts() {
        accounts = try? accountService.fetch()
    }
    
    func deleteAccount(index: IndexSet) {
        guard let allAccounts = accounts else {
            return
        }
        
        let selectedAccounts = index.map({ allAccounts[$0] })
        
        do {
            try accountService.delete(accounts: selectedAccounts)
        } catch {
            return
        }
        
        accounts?.remove(atOffsets: index)
    }
}

extension Resolver {
    static func RegisterEditAccountsViewModel() {
        register { EditAccountsViewModel() }
    }
}
