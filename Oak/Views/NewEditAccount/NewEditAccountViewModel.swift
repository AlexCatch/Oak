//
//  NewAccountViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 05/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class NewEditAccountViewModel: ObservableObject {
    @Injected private var accountsService: AccountService
    
    @Published var account: Account?
    
    @Published var name = ""
    @Published var issuer = ""
    @Published var secret = ""
    @Published var base32Encoded = true
    @Published var type: CodeType = .totp
    @Published var algorithm: Algorithm = .sha1
    @Published var digits: Int = 6
    @Published var period: Int = 30
    
    @Published var saveError: String?
    
    var isEditing: Bool {
        return account != nil
    }
    
    var inputsValid: Bool {
        return
            !name.trimmed().isEmpty &&
            !issuer.trimmed().isEmpty &&
            !secret.isEmpty
    }
    
    var navigationTitle: String {
        return account != nil ? "Edit Account" : "New Account"
    }
    
    func setAccount(account: Account?) {
        guard let account = account else {
            return
        }
        
        self.account = account
        
        if let username = account.username {
            self.name = username
        }
        
        issuer = account.issuer
        secret = account.secret
        base32Encoded = account.usesBase32
        type = account.type
        algorithm = account.algorithm
        digits = account.digits
        
        if let period = account.period.value {
            self.period = period
        }
    }
    
    func save(dismiss: () -> Void) {
        do {
            let data = CreateAccountData(name: name, issuer: issuer, secret: secret, base32Encoded: base32Encoded, type: type, algorithm: algorithm, digits: digits, period: type == .totp ? period : nil)
            try accountsService.save(data: data)
            dismiss()
        } catch {
            saveError = "Failed to create account."
        }
    }
}

extension Resolver {
    static func RegisterNewAccountViewModel() {
        register { NewEditAccountViewModel() }
    }
}
