//
//  MockPersistentStore.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import Foundation
import CoreData

public class MockPersistentStore: PersistentStore {
    private var persistentContainer: NSPersistentContainer!
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public init() {
        let bundle = Bundle.module
        let modelURL = bundle.url(forResource: "Oak", withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        persistentContainer = NSPersistentContainer(name: "Oak", managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores(completionHandler: { _, error in
          if let error = error as NSError? {
            fatalError("Failed to load stores: \(error), \(error.userInfo)")
          }
        })
    }
    
    public func save() throws {
        try viewContext.save()
    }
    
    public func toggleICloudSync(sync: Bool) {}
    
    public func deleteUserAccounts() {}
}
