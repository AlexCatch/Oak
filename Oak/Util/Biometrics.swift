//
//  Biometrics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
@preconcurrency import LocalAuthentication
import Dependencies

struct Biometrics {
    var enabled: @Sendable () -> Bool
    var authenticate: @Sendable () async -> Bool
}

extension Biometrics: DependencyKey {
    static var liveValue: Self {
        let context = LAContext()
        return Biometrics {
            var error: NSError?
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                print(error?.localizedDescription ?? "Failed to evaluate policy")
                return false
            }
            return true
        } authenticate: {
            let reason = context.biometryType == .faceID ? "Use Face ID to unlock Oak" : "Use Touch ID to unlock Oak"
            do {
                _ = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
                return true
            } catch {
                return false
            }
        }
    }
    static var previewValue: Self {
        return Biometrics {
            false
        } authenticate: {
            return false
        }

    }
    static var testValue: Self {
        return .previewValue
    }
}

extension DependencyValues {
    var biometrics: Biometrics {
        get { self[Biometrics.self] }
        set { self[Biometrics.self] = newValue }
    }
}
