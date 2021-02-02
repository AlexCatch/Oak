//
//  UpdatePasswordViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class UpdatePasswordViewModel: ObservableObject {
    @Injected private var keychainService: KeychainService
    @Injected private var haptics: Haptics
    
    @Published var enteredCurrentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var newPasswordConfirm: String = ""
    @Published var updatePasswordError: String?
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(get: {
            return self.updatePasswordError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.updatePasswordError = nil
        })
    }
    
    var inputsAreValid: Bool {
        return (
            !enteredCurrentPassword.isEmpty &&
            !newPassword.isEmpty &&
            !newPasswordConfirm.isEmpty &&
            (newPassword == newPasswordConfirm)
        )
    }
    
    func saveChanges() -> Bool {
        let currentPassword = keychainService.get(key: .Password)
        guard currentPassword == enteredCurrentPassword else {
            // current password doesn't match the entered
            self.updatePasswordError = "Your current password is incorrect."
            haptics.generate(type: .error)
            return false
        }
        
        keychainService.set(key: .Password, value: newPassword)
        return true
    }
}

extension Resolver {
    static func RegisterUpdatePasswordViewModel() {
        register { UpdatePasswordViewModel() }
    }
}
