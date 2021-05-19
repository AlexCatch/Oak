//
//  PersistantStore.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

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
}

class RealPersistentStore: PersistentStore {
    private var persistentContainer: NSPersistentContainer!
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func setupContainer() {
        self.persistentContainer = NSPersistentContainer(name: "Oak")
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    init() {
        setupContainer()
    }
    
    func save() throws {
        try viewContext.save()
    }
}

extension Resolver {
    static func RegisterPersistentContainer() {
        register { RealPersistentStore() as PersistentStore }.scope(.application)
    }
}
