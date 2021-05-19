//
//  Services+Injected.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import Foundation
import Resolver

extension Resolver {
    static func RegisterAllAppServices() {
        RegisterOTPService()
        RegisterAccountService()
    }
}
