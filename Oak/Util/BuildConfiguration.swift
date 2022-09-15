//
//  BuildEnvironment.swift
//  OakOTP
//
//  Created by Alex Catchpole on 15/09/2022.
//

import Foundation
import Resolver

enum BuildEnvironment: String { // 1
    case debugDevelopment = "Debug Development"
    case debugProduction = "Debug Production"
    
    case releaseProduction = "Release Production"
    case releaseDevelopment = "Release Development"
}

class BuildConfiguration { // 2
    var environment: BuildEnvironment
    
    var ICloudContainerName: String {
        switch environment {
        case .debugProduction, .debugDevelopment:
            return "iCloud.sh.catch.oakdebug.icloud"
        case .releaseDevelopment, .releaseProduction:
            return "iCloud.sh.catch.oak.icloud"
        }
    }
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = BuildEnvironment(rawValue: currentConfiguration)!
    }
}

extension Resolver {
    static func RegisterBuildConfigurationUtil() {
        register { BuildConfiguration() }.scope(.application)
    }
}
