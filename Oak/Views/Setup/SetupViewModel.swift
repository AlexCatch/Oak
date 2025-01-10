//
//  SetupViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Dependencies

class SetupViewModel: ObservableObject {
    @Dependency(\.keychainService)private var keychainService: KeychainService
    @Dependency(\.settings) private var settings: Settings
    
    @Published var password: String = ""
    @Published var passwordConfirmation = ""
    @Published var errorMessage: String?
    @Published var biometricsEnabled = false
    
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
        keychainService.set(.password, password)
        settings.set(true, forKey: .isSetup)
    }
}
