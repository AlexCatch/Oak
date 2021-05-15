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
    @Published var counter: Int = 1
    
    @Published var saveError: String?
    @Published var deletionRequested = false
    
    var dismiss: (() -> Void)?
    
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
        
        if let name = account.name {
            self.name = name
        }
        
        if let issuer = account.issuer {
            self.issuer = issuer
        }
        
        if let secret = account.secret {
            self.secret = secret
        }
        
        if let type = account.type {
            self.type = type
        }
        
        base32Encoded = account.usesBase32
    
        algorithm = account.algorithm
        digits = Int(account.digits)
        period = Int(account.period)
        counter = Int(account.counter)
    }
    
    func save() {
        guard let dismiss = self.dismiss else {
            return
        }
        
        do {
            if self.account != nil {
                try updateAccount()
            } else {
                try newAccount()
            }
            dismiss()
        } catch {
            saveError = "Failed to create account."
        }
    }
    
    func requestDelete() {
        deletionRequested = true
    }
    
    func confirmDeletion() {
        guard let account = account else {
            return
        }
        try? accountsService.delete(accounts: [account])
        dismiss?()
    }
    
    private func newAccount() throws {
        let data = CreateAccountData(name: name, issuer: issuer, secret: secret, base32Encoded: base32Encoded, type: type, algorithm: algorithm, digits: digits, period: type == .totp ? period : nil, counter: type == .hotp ? counter : nil)
        try accountsService.save(data: data)
    }
    
    private func updateAccount() throws {
        guard let existingAccount = account else {
            return
        }
        existingAccount.name = name
        existingAccount.issuer = issuer
        existingAccount.secret = secret
        existingAccount.usesBase32 = base32Encoded
        existingAccount.type = type
        existingAccount.algorithm = algorithm
        existingAccount.digits = Int16(digits)
        existingAccount.period = type == .totp ? Int16(period) : 30
        existingAccount.counter = type == .hotp ? Int16(counter) : 1
        try accountsService.save(account: existingAccount)
    }
}

extension Resolver {
    static func RegisterNewAccountViewModel() {
        register { NewEditAccountViewModel() }
    }
}
