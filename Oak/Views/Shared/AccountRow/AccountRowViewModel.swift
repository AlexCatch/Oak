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
    
    @Injected private var haptics: Haptics
    @Injected private var otpService: OTPService
    
    @Published var accountDisplayable: AccountDisplayable
    @Published var hasCopied = false
    var account: Account
    
    init(account: Account) {
        self.accountDisplayable = AccountDisplayable(id: account.id, name: account.issuer, username: account.username)
        self.account = account.freeze()
    }
    
    func copyCode() {
        guard let code = try? otpService.generateCode(account: account) else {
            return
        }
        
        haptics.generate(type: .success)
        UIPasteboard.general.string = code
        
        // we'll tell our code view we've copied for 3 seconds before toggling it back
        hasCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.hasCopied = false
        }
    }
    
    func codeView() -> AnyView {
        if account.type == .hotp {
            return AnyView(HOTPCodeView(hasCopied: hasCopied, account: account))
        }
        return AnyView(TOTPCodeView(hasCopied: hasCopied, account: account))
    }
}
