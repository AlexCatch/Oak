//
//  MockPersistentStore.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import Foundation
import CoreData
@testable import OakOTP

class MockPersistentStore: PersistentStore {
    private var persistentContainer: NSPersistentContainer!
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Oak")

        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores(completionHandler: { _, error in
          if let error = error as NSError? {
            fatalError("Failed to load stores: \(error), \(error.userInfo)")
          }
        })
    }
    
    func save() throws {
        try viewContext.save()
    }
    
    func toggleICloudSync(sync: Bool) {}
    
    func deleteUserAccounts() {}
}
