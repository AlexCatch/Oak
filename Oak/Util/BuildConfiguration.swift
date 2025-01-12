//
//  BuildEnvironment.swift
//  OakOTP
//
//  Created by Alex Catchpole on 15/09/2022.
//

import Foundation
import Dependencies

enum BuildEnvironment: String { // 1
    case debug = "Debug"
    case release = "Release"
}

struct BuildConfiguration {
    var environment: BuildEnvironment
    var ICloudContainerName: String {
        switch environment {
        case .debug:
            return "iCloud.sh.catch.oakdebug.icloud"
        case .release:
            return "iCloud.sh.catch.oak.icloud"
        }
    }
    
    init(configuration: String) {
        environment = BuildEnvironment(rawValue: configuration) ?? BuildEnvironment.debug
    }
}

extension BuildConfiguration: DependencyKey {
    static var liveValue: Self {
        let configuration = (Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String) ?? BuildEnvironment.debug.rawValue
        return BuildConfiguration(configuration: configuration)
    }
}

extension DependencyValues {
    var buildConfiguration: BuildConfiguration {
        get { self[BuildConfiguration.self] }
        set { self[BuildConfiguration.self] = newValue }
    }
}

