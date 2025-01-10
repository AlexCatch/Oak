//
//  BuildEnvironment.swift
//  OakOTP
//
//  Created by Alex Catchpole on 15/09/2022.
//

import Foundation
import Dependencies

enum BuildEnvironment: String { // 1
    case debugDevelopment = "Debug Development"
    case debugProduction = "Debug Production"
    
    case releaseProduction = "Release Production"
    case releaseDevelopment = "Release Development"
}

struct BuildConfiguration {
    var environment: BuildEnvironment
    var ICloudContainerName: String {
        switch environment {
        case .debugProduction, .debugDevelopment:
            return "iCloud.sh.catch.oakdebug.icloud"
        case .releaseDevelopment, .releaseProduction:
            return "iCloud.sh.catch.oak.icloud"
        }
    }
    
    init(configuration: String) {
        environment = BuildEnvironment(rawValue: configuration) ?? BuildEnvironment.debugDevelopment
    }
}

extension BuildConfiguration: DependencyKey {
    static var liveValue: Self {
        let configuration = (Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String) ?? BuildEnvironment.debugDevelopment.rawValue
        return Self.init(configuration: configuration)
    }
}

extension DependencyValues {
    var buildConfiguration: BuildConfiguration {
        get { self[BuildConfiguration.self] }
        set { self[BuildConfiguration.self] = newValue }
    }
}

