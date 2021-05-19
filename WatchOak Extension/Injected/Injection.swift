//
//  Injection.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        RegisterAllAppServices()
        RegisterAllViewModels()
        RegisterPersistentContainer()
    }
}
