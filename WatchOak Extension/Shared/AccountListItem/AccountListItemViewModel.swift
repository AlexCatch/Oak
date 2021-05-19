//
//  AccountListItemViewModel.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import Foundation
import SwiftUI
import Resolver

class AccountListItemViewModel: Identifiable, ObservableObject {
    var id: String {
        get {
            return account.objectID.uriRepresentation().absoluteString
        }
    }
    
    @Injected private var otpService: OTPService
    
    @Published var account: Account
    
    var isHOTP: Bool {
        get {
            return account.type == .hotp
        }
    }
    
    init(account: Account) {
        self.account = account
    }
}
