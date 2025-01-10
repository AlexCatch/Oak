//
//  ModelContainer.swift
//  OakOTP
//
//  Created by Alex on 10/01/2025.
//

import Foundation
import SwiftData
import Dependencies

@Observable
class ModelManager {
    @ObservationIgnored
    @Dependency(\.buildConfiguration) var buildConfiguration: BuildConfiguration
    
    @ObservationIgnored
    @Dependency(\.iCloudSettings) var ICloudSettings: ICloudSettings
    
    var modelContainer: ModelContainer!
    
    init() {
        setupContainer(sync: ICloudSettings.bool(forKey: .iCloudEnabled) ?? false)
    }
    
    func setupContainer(sync: Bool) {
        let schema = Schema([
            Account.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: sync ? .private(buildConfiguration.ICloudContainerName) : .none)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

private enum ModelManagerKey: DependencyKey {
    static var liveValue = ModelManager()
}

extension DependencyValues {
    var modelManager: ModelManager {
        get { self[ModelManagerKey.self] }
        set { self[ModelManagerKey.self] = newValue }
    }
}
