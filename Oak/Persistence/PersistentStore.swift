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
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() {
        print("PersistentStore")
        self.persistentContainer = NSPersistentContainer(name: "Oak")
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() throws {
        try viewContext.save()
    }
    
    deinit {
        print("PersistentStore is being deallocated and it shouldnt")
    }
}

extension Resolver {
    static func RegisterPersistentContainer() {
        register { PersistentStore() }.scope(.application)
    }
}
