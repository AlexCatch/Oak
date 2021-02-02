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
    
    @Published var password: String = ""
    @Published var passwordConfirmation = ""
    @Published var errorMessage: String?
    
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
    
    func setup(with rootViewBinding: Binding<RootView>) {
        keychainService.set(key: .Password, value: password)
        rootViewBinding.wrappedValue = .Accounts
    }
}

extension Resolver {
    static func RegisterSetupViewModel() {
        register { SetupViewModel() }
    }
}
