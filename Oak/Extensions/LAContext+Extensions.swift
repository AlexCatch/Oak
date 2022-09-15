//
//  LAContext+Extensions.swift
//  OakOTP
//
//  Created by Alex Catchpole on 14/09/2022.
//

import Foundation
import LocalAuthentication

extension LAContext {
    func evaluatePolicy(_ policy: LAPolicy, localizedReason reason: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { cont in
            LAContext().evaluatePolicy(policy, localizedReason: reason) { result, error in
                if let error = error { return cont.resume(throwing: error) }
                cont.resume(returning: result)
            }
        }
    }
}
