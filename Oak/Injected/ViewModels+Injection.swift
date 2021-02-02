//
//  ViewModels+Injection.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import Resolver

extension Resolver {
    static func RegisterAllViewModels() {
        RegisterAccountsViewModel()
        RegisterScanQRCodeViewModel()
        RegisterSetupViewModel()
        RegisterMainViewModel()
        RegisterAuthenticationViewModel()
        RegisterUpdatePasswordViewModel()
        RegisterEditAccountsViewModel()
        RegisterSettingsViewModel()
    }
}
