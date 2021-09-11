//
//  Setup.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import Foundation
import OakOTPCommon
@testable import OakOTP
import OakOTPCommon
import Resolver

extension Resolver {
    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(parent: .main)
        Resolver.root = .test
        
        Resolver.test.register { MockKeychainService() as KeychainService }.scope(.shared)
        Resolver.test.register { MockSettings() as Settings }.scope(.shared)
        Resolver.test.register { MockPersistentStore() as PersistentStore }.scope(.shared)
    }
}
