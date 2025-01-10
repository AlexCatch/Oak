//
//  Biometrics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import LocalAuthentication
import Dependencies

protocol Biometrics {
    func enabled() -> Bool
    func authenticate() async -> Bool
}

class LiveBiometrics: Biometrics {
    let context = LAContext()
    
    func enabled() -> Bool {
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (context.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            if error != nil {
                return false
            }
            return context.biometryType != .none
        }
        return false
    }
    
    func authenticate() async -> Bool {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if error != nil {
                // TODO - Add Sentry Errors
                return false
            }
            
            let reason = context.biometryType == .faceID ? "Use Face ID to unlock Oak" : "Use Touch ID to unlock Oak"
            let isAuthenticated = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            return isAuthenticated ?? false
        } else {
            return true
        }
    }
}

private enum BiometricsKey: DependencyKey {
    static let liveValue: any Biometrics = LiveBiometrics()
}

extension DependencyValues {
    var biometrics: Biometrics {
        get { self[BiometricsKey.self] }
        set { self[BiometricsKey.self] = newValue }
    }
}
