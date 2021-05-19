//
//  AccountRowViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class AccountRowViewModel: Identifiable, ObservableObject {
    var id: String {
        get {
            return account.objectID.uriRepresentation().absoluteString
        }
    }
    
    @Injected private var haptics: Haptics
    @Injected private var otpService: OTPService
    
    @Published var account: Account
    @Published var hasCopied = false
    
    init(account: Account) {
        self.account = account
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
