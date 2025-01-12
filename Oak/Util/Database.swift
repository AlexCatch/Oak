//
//  ModelContainer.swift
//  OakOTP
//
//  Created by Alex on 10/01/2025.
//

import Foundation
import SwiftData
import Dependencies

public class SwiftDataModelConfigurationProvider {
    // Singleton instance for configuration
    @MainActor public static let shared = SwiftDataModelConfigurationProvider(isStoredInMemoryOnly: false, autosaveEnabled: true)
    
    @Dependency(\.buildConfiguration) var buildConfiguration
    @Dependency(\.iCloudSettings) var iCloudSettings
    
    // Properties to manage configuration options
    private var isStoredInMemoryOnly: Bool
    private var autosaveEnabled: Bool
    
    // Private initializer to enforce singleton pattern
    private init(isStoredInMemoryOnly: Bool, autosaveEnabled: Bool) {
        self.isStoredInMemoryOnly = isStoredInMemoryOnly
        self.autosaveEnabled = autosaveEnabled
    }
    
    @MainActor func createContainer() -> ModelContainer {
        // Define schema and configuration
        let schema = Schema(
            [
                Account.self,
            ]
        )
        let shouldSync = iCloudSettings.bool(.iCloudEnabled) ?? false
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: shouldSync ? .private(buildConfiguration.ICloudContainerName) : .none)
        // Create ModelContainer with schema and configuration
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        return container
    }
    
    // Lazy initialization of ModelContainer
    @MainActor
    public lazy var container: ModelContainer = {
        return createContainer()
    }()
}
