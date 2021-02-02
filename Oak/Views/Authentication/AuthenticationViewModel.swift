//
//  AuthenticationViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class AuthenticationViewModel: ObservableObject {
    @Injected private var settings: Settings
    @Injected private var biometrics: Biometrics
    @Injected private var haptics: Haptics
    @Injected private var keychainService: KeychainService
    
    @Published var password: String = ""
    
    var passwordValid: Bool {
        return !password.isEmpty
    }
    
    func attemptBiometrics(with rootViewBinding: Binding<RootView>) {
        guard settings.bool(key: .biometricsEnabled) else {
            // biometrics aren't enabled at the app level
            return
        }
        
        biometrics.enabled { (success: Bool) in
            guard success else {
                //biometrics aren't supported at the device level
                return
            }
            
            biometrics.authenticate { (success: Bool) in
                guard success else {
                    // Failed to authenticate
                    return
                }
                
                self.haptics.generate(type: .success)
                rootViewBinding.wrappedValue = .Accounts
            }
        }
    }
    func authenticatePassword(with rootViewBinding: Binding<RootView>) {
        let storedPassword = keychainService.get(key: .Password)

        guard storedPassword == password else {
            haptics.generate(type: .error)
            return
        }
        
        haptics.generate(type: .success)
        // success auth - go to accounts
        rootViewBinding.wrappedValue = .Accounts
    }
}

extension Resolver {
    static func RegisterAuthenticationViewModel() {
        register { AuthenticationViewModel() }
    }
}
