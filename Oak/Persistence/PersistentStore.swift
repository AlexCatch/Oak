//
//  PersistentStore.swift
//  Oak
//
//  Created by Alex Catchpole on 11/02/2021.
//

import Foundation
import Resolver
import CoreData

class PersistentStore {
    private var persistentContainer: NSPersistentContainer!
    @Injected private var iCloudSettings: ICloudSettings
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func setupContainer(sync: Bool) {
        self.persistentContainer = NSPersistentCloudKitContainer(name: "Oak")
        
        guard let description = self.persistentContainer.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        description.setOption(true as NSNumber,
                                    forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        // If iCloud sync is disabled, prevent syncing
        if !sync {
            description.cloudKitContainerOptions = nil
        }
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        try? viewContext.setQueryGenerationFrom(.current)
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
    init() {
        setupContainer(sync: iCloudSettings.bool(key: .iCloudEnabled))
    }
    
    func save() throws {
        try viewContext.save()
    }
    
    deinit {
        print("PersistentStore is being deallocated and it shouldnt")
    }
    
    public func toggleICloudSync(sync: Bool) {
        setupContainer(sync: sync)
    }
    
    public func deleteUserAccounts() {
        let container = CKContainer(identifier: "iCloud.sh.catch.oak.icloud")
        let database = container.privateCloudDatabase
        
        database.delete(withRecordZoneID: .init(zoneName: "com.apple.coredata.cloudkit.zone"), completionHandler: { (zoneID, error) in
            if let error = error {
                // If we failed to delete we need to mark somewhere that we failed so it's time to try again on relaunch
                self.iCloudSettings.set(key: .failedToDeleteZone, value: true)
                print("deleting zone error \(error.localizedDescription)")
            } else {
                print("did delete entire zone")
            }
        })
    }
}

extension Resolver {
    static func RegisterPersistentContainer() {
        register { PersistentStore() }.scope(.application)
    }
}
