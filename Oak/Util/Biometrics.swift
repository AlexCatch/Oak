//
//  Biometrics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import LocalAuthentication
import Resolver

class Biometrics {
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
    
    func authenticate(onComplete: @escaping (_ success: Bool) -> Void) {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if error != nil {
                onComplete(false)
                return
            }
            
            let reason = context.biometryType == .faceID ? "Use Face ID to unlock Oak" : "Use Touch ID to unlock Oak"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    onComplete(success)
                }
            }
        } else {
            onComplete(true)
        }
    }
}

extension Resolver {
    static func RegisterBiometricsUtil() {
        register { Biometrics() }.scope(.shared)
    }
}
