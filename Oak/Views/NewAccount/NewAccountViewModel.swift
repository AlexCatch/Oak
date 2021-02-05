//
//  NewAccountViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 05/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class NewAccountViewModel: ObservableObject {
    @Injected private var accountsService: AccountService
    
    @Published var name = ""
    @Published var issuer = ""
    @Published var secret = ""
    @Published var base32Encoded = true
    @Published var type: CodeType = .totp
    @Published var algorithm: Algorithm = .sha1
    @Published var digits: Int = 6
    @Published var period: Int = 30
    
    @Published var saveError: String?
    
    var inputsValid: Bool {
        return
            !name.trimmed().isEmpty &&
            !issuer.trimmed().isEmpty &&
            !secret.isEmpty
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
        register { NewAccountViewModel() }
    }
}
