//
//  Setup.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import Foundation
import OakOTPCommon
import Resolver

extension Resolver {
    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(parent: .main)
        Resolver.root = .test
        
        Resolver.test.register { MockPersistentStore() as PersistentStore }.scope(.shared)
    }
}
