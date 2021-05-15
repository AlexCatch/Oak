//
//  Account.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import Foundation
import CoreData
import SwiftOTP

extension Account {
    var algorithm: Algorithm {
        set {
            algorithmRaw = newValue.rawValue
        }
        get {
            guard let rawAlgo = algorithmRaw else {
                return .sha1
            }
            // litterally cannot go tits up
            return Algorithm(rawValue: rawAlgo) ?? .sha1
        }
    }
    
    var type: CodeType? {
        set {
            typeRaw = newValue?.rawValue
        }
        get {
            guard let rawType = typeRaw else {
                return nil
            }
            // litterally cannot go tits up
            return CodeType(rawValue: rawType)!
        }
    }
    
    func decodeSecret() -> Data? {
        guard let secret = secret else {
            return nil
        }
        
        if usesBase32 {
            return base32DecodeToData(secret) ?? secret.data(using: .utf8)
        }
        
        return secret.data(using: .utf8)
    }
}

extension NSManagedObject {
    static func resultsController<T>(context: NSManagedObjectContext, request: NSFetchRequest<T>, sortDescriptors: [NSSortDescriptor] = []) -> NSFetchedResultsController<T> {
        request.sortDescriptors = sortDescriptors
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}
