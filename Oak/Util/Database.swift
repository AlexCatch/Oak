//
//  ModelContainer.swift
//  OakOTP
//
//  Created by Alex on 10/01/2025.
//

import Foundation
import SwiftData
import Dependencies

@MainActor
protocol Database: Sendable {
    var modelContainer: ModelContainer { get }
    func toggleICloudSync(sync: Bool) async
}

class LiveDatabase: Database {
    
    @Dependency(\.buildConfiguration) var buildConfiguration
    @Dependency(\.iCloudSettings) var iCloudSettings
    
    lazy var modelContainer: ModelContainer = {
        return createContainer(sync: iCloudSettings.bool(.iCloudEnabled) ?? false)
    }()
    
    func createContainer(sync: Bool) -> ModelContainer {
        let schema = Schema([
            Account.self,
        ])
        let sync = iCloudSettings.bool(.iCloudEnabled) ?? false
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: sync ? .private(buildConfiguration.ICloudContainerName) : .none)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // TODO: - Handle better
            fatalError("ModelContainer failed to init")
        }
    }
    
    func toggleICloudSync(sync: Bool) {
        modelContainer = createContainer(sync: sync)
    }
}

private enum DatabaseKey: DependencyKey {
    static let liveValue: any Database = LiveDatabase()
}

extension DependencyValues {
    var database: Database {
        get { self[DatabaseKey.self] }
        set { self[DatabaseKey.self] = newValue }
    }
}
