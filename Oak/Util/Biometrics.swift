//
//  Biometrics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import LocalAuthentication

class Biometrics {
    let context = LAContext()
    
    func enabled(callback: (_ success: Bool) -> Void) {
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        if (context.canEvaluatePolicy(biometricsPolicy, error: &error)) {

            if error != nil {
                callback(false)
                return
            }
            callback(context.biometryType != .none)
        }
    }
    
    func authenticate(onComplete: @escaping (_ success: Bool) -> Void) {
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
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
