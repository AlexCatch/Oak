//
//  Injection.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        RegisterAllRepositories()
        RegisterAllAppServices()
        RegisterAllViewModels()
    }
}

