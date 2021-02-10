//
//  HOTPCodeViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 07/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class HOTPCodeViewModel: ObservableObject, CodeViewModel {
    @Injected private var otpService: OTPService
    @Injected private var accountService: AccountService
    
    @Published var code: String = ""
    
    var account: Account?
    
    func generateCode(increment: Bool) {
        
        // increment the account's counter and then generate
        if let account = account, increment, let updatedAccount = try? accountService.updateCounter(account: account) {
            self.account = updatedAccount
        }
        print(self.account)
        guard let account = account, let code = try? otpService.generateCode(account: account) else {
            self.code = "Error"
            return
        }
        
        self.code = formatCode(code: code)
    }
    
    func setAccount(account: Account) {
        if self.account == nil {
            self.account = account
        }
    }
}

extension Resolver {
    static func RegisterHOTPCodeViewModel() {
        register { HOTPCodeViewModel() }
    }
}
