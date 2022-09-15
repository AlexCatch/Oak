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
    @Published var authFailed = false
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationWillEnterForeground() {
        Task {
            await attemptBiometrics(for: .active)
        }
    }
    
    @MainActor
    func attemptBiometrics(for scenePhase: ScenePhase) async {
        guard settings.bool(key: .biometricsEnabled), scenePhase == .active || scenePhase == .inactive else {
            // biometrics aren't enabled at the app level
            return
        }
        
        guard biometrics.enabled() else {
            return
        }
        
        let isAuthenticated = await biometrics.authenticate()
        
        guard isAuthenticated else {
            // Failed to authenticate
            return
        }
        
        self.haptics.generate(type: .success)
        if let binding = self.rootViewBinding {
            binding.wrappedValue = .accounts
        }
    }
    
    func authenticatePassword() -> Bool {
        let storedPassword = keychainService.get(key: .password)

        guard storedPassword == password else {
            haptics.generate(type: .error)
            authFailed = true
            return false
        }
        
        haptics.generate(type: .success)
        return true
    }
}

extension Resolver {
    static func RegisterAuthenticationViewModel() {
        register { AuthenticationViewModel() }
    }
}
