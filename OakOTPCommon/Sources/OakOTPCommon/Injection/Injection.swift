//
//  File.swift
//  
//
//  Created by Alex Catchpole on 11/09/2021.
//

import Foundation
import Resolver

public struct Injection {
    public static func registerComponents(in container: Resolver) {
        container.register { RealPersistentStore() as PersistentStore }.scope(.application)
        container.register { RealSettings() as Settings }.scope(.shared)
        container.register { ICloudSettings() }.scope(.shared)
        container.register { RealAccountService() as RealAccountService }.scope(.shared)
        container.register { RealOTPService() as RealOTPService }.scope(.shared)
    }
}
