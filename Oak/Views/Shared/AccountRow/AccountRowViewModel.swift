//
//  AccountRowViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import SwiftUI
import Resolver

struct AccountDisplayable: Identifiable {
    var id: String
    var name: String
    var username: String?
}

class AccountRowViewModel: Identifiable, ObservableObject {
    var id: String {
        get {
            return account.id
        }
    }
    
    @Injected private var otpService: OTPService
    
    @Published var accountDisplayable: AccountDisplayable
    let account: Account
    
    init(account: Account) {
        self.accountDisplayable = AccountDisplayable(id: account.id, name: account.issuer, username: account.username)
        self.account = account.freeze()
    }
}
