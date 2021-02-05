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
    
    var rootViewBinding: Binding<RootView>?
    
    @Published var password: String = ""
    
    var passwordValid: Bool {
        return !password.isEmpty
    }
    
    init() {
        /*
         Listen for when application goes into the foreground and attempt biometrics,
         this will handle requiring auth when becoming active
         */
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func applicationWillEnterForeground() {
        attemptBiometrics(for: .active)
    }
    
    func attemptBiometrics(for scenePhase: ScenePhase) {
        guard settings.bool(key: .biometricsEnabled), scenePhase == .active else {
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
                if let binding = self.rootViewBinding {
                    binding.wrappedValue = .accounts
                }
            }
        }
    }
    
    func authenticatePassword(with rootViewBinding: Binding<RootView>) {
        let storedPassword = keychainService.get(key: .password)

        guard storedPassword == password else {
            haptics.generate(type: .error)
            return
        }
        
        haptics.generate(type: .success)
        // success auth - go to accounts
        rootViewBinding.wrappedValue = .accounts
    }
}

extension Resolver {
    static func RegisterAuthenticationViewModel() {
        register { AuthenticationViewModel() }
    }
}
