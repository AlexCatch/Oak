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

extension Account: Encodable {
    private enum CodingKeys: String, CodingKey { case counter, digits, order, period, algorithmRaw, issuer, name, secret, typeRaw, usesBase32, createdAt }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(counter, forKey: .counter)
        try container.encode(digits, forKey: .digits)
        try container.encode(order, forKey: .order)
        try container.encode(period, forKey: .period)
        try container.encode(algorithmRaw, forKey: .algorithmRaw)
        try container.encode(issuer, forKey: .issuer)
        try container.encode(name, forKey: .name)
        try container.encode(secret, forKey: .secret)
        try container.encode(typeRaw, forKey: .typeRaw)
        try container.encode(usesBase32, forKey: .usesBase32)
        try container.encode(createdAt, forKey: .createdAt)
    }
}

extension NSManagedObject {
    static func resultsController<T>(context: NSManagedObjectContext, request: NSFetchRequest<T>, sortDescriptors: [NSSortDescriptor] = []) -> NSFetchedResultsController<T> {
        request.sortDescriptors = sortDescriptors
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}
