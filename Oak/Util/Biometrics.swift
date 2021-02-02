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
    
    init() {
        context.localizedCancelTitle = "Password"
    }
    
    func authenticate(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        print("success")
                        onSuccess()
                    } else {
                        print("failed")
                        onFailure()
                    }
                }
            }
        } else {
            // no biometry
            print("no biometty")
            onFailure()
        }
    }
}
