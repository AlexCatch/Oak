//
//  SetupViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class SetupViewModel: ObservableObject {
    @Injected private var keychainService: KeychainService
    @Injected private var settings: Settings
    
    @Published var password: String = ""
    @Published var passwordConfirmation = ""
    @Published var errorMessage: String?
    @Published var biometricsEnabled = Biometrics().enabled()
    
    var areInputsValid: Bool {
        return
            !password.isEmpty &&
            !passwordConfirmation.isEmpty &&
            password == passwordConfirmation
    }
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(get: {
            return self.errorMessage != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.errorMessage = nil
        })
    }
    
    func setup() {
        keychainService.set(key: .password, value: password)
        settings.set(key: .isSetup, value: true)
    }
}

extension Resolver {
    static func RegisterSetupViewModel() {
        register { SetupViewModel() }
    }
}
