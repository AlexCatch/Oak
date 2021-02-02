//
//  AccountRowViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation

class AccountRowViewModel: Identifiable, ObservableObject {
    var account: AccountDisplayable
    
    var id: String {
        get {
            return account.id
        }
    }
    
    @Published var issuer: String = ""
    @Published var username: String?
    
    init(account: Account) {
        self.account = AccountDisplayable(id: account.id, name: account.issuer, username: account.username)
        self._issuer = Published(initialValue: account.issuer)
        self._username = Published(initialValue: account.username)
    }
}
