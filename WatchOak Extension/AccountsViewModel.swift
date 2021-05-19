//
//  AccountsViewModel.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import Foundation
import SwiftUI
import Resolver

class AccountsViewModel: NSObject, AccountServiceDelegate, ObservableObject {
    @Injected private var accountService: AccountService
    
    @Published var accountListItemViewModels: [AccountListItemViewModel] = []
    
    override init() {
        super.init()
        accountService.delegate = self
    }
    
    func accountsChanged(accounts: [Account]) {
        self.accountListItemViewModels = accounts.map { AccountListItemViewModel(account: $0) }
    }
}

extension Resolver {
    static func RegisterAccountsViewModel() {
        register { AccountsViewModel() }
    }
}

