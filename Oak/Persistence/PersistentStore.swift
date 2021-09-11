//
//  PersistentStore.swift
//  Oak
//
//  Created by Alex Catchpole on 11/02/2021.
//

import Foundation
import Resolver
import CoreData

protocol PersistentStore {
    var viewContext: NSManagedObjectContext { get }
    func save() throws
    func toggleICloudSync(sync: Bool)
    func deleteUserAccounts()
}

class RealPersistentStore: PersistentStore {
    
    private var persistentContainer: NSPersistentContainer!
    @Injected private var iCloudSettings: ICloudSettings
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func setupContainer(sync: Bool) {
        self.persistentContainer = NSPersistentCloudKitContainer(name: "Oak")
        
        guard let existingDescription = self.persistentContainer.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        
        var appStoreURL: URL?
        if let url = existingDescription.url {
            appStoreURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
        }
        
        let AppGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.sh.catch.data")!.appendingPathComponent("\(self.persistentContainer.name).sqlite")
        
        var storeURL: URL
        
        if let url = appStoreURL, FileManager.default.fileExists(atPath: url.path) {
            storeURL = url
        } else {
            storeURL = AppGroupUrl
        }
        
        let description = NSPersistentStoreDescription(url: storeURL)
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        if !sync {
            description.cloudKitContainerOptions = nil
        } else {
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.sh.catch.oak.icloud")
        }
        
        self.persistentContainer.persistentStoreDescriptions = [description]
        
        // Migrate if we've got an old store
        if let nonAppGroupUrl = appStoreURL {
            migrateStore(for: self.persistentContainer, appGroupStoreURL: AppGroupUrl, AppStoreURL: nonAppGroupUrl)
        }
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        try? viewContext.setQueryGenerationFrom(.current)
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private func migrateStore(for container: NSPersistentContainer, appGroupStoreURL: URL, AppStoreURL: URL) {

        // you only ever want to run this once so once the old one is gone then drop out.
        if !FileManager.default.fileExists(atPath: AppStoreURL.path){
            return
        }

        // see what configuration you're going to apply to the new store
        for persistentStoreDescription in container.persistentStoreDescriptions {
            do {
                try container.persistentStoreCoordinator.replacePersistentStore(
                    at: appGroupStoreURL,  //destination
                    destinationOptions: persistentStoreDescription.options,
                    withPersistentStoreFrom: AppStoreURL, // source
                    sourceOptions: persistentStoreDescription.options,
                    ofType: persistentStoreDescription.type
                )
            } catch {
                print("[--] failed to copy persistence store: \(error.localizedDescription)")
            }

        }
        // WARN: it works but feels wrong to me. this is where you should be cautious
        // assumes you have one store while above loop does not.
        container.persistentStoreDescriptions.first!.url = appGroupStoreURL

        do {
            try FileManager.default.removeItem(at: AppStoreURL)
        } catch {
            print("Something went wrong while deleting the old store: \(error.localizedDescription)")
        }
    }
    
    init() {
        setupContainer(sync: iCloudSettings.bool(key: .iCloudEnabled))
    }
    
    func save() throws {
        try viewContext.save()
    }
    
    public func toggleICloudSync(sync: Bool) {
        setupContainer(sync: sync)
    }
    
    public func deleteUserAccounts() {
        let container = CKContainer(identifier: "iCloud.sh.catch.oak.icloud")
        let database = container.privateCloudDatabase
        
        database.delete(withRecordZoneID: .init(zoneName: "com.apple.coredata.cloudkit.zone"), completionHandler: { (zoneID, error) in
            if error != nil {
                // If we failed to delete we need to mark somewhere that we failed so it's time to try again on relaunch
                self.iCloudSettings.set(key: .failedToDeleteZone, value: true)
            }
        })
    }
}

extension Resolver {
    static func RegisterPersistentContainer() {
        register { RealPersistentStore() as PersistentStore }.scope(.application)
    }
}




