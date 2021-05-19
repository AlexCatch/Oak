//
//  HOTPCodeViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import CoreData
import Resolver
@testable import OakOTP

class HOTPCodeViewModelTests: OakTestCase {
    private func createAccount(context: NSManagedObjectContext) -> Account {
        let account = Account(context: context)
        account.issuer = "Google"
        account.name = "john@doe.co.uk"
        account.secret = "helloworld"
        account.algorithm = .sha1
        account.type = .hotp
        account.usesBase32 = false
        account.createdAt = Date()
        account.digits = Int16(6)
        return account
    }
    
    func testIncrement() {
        let persistence: PersistentStore = Resolver.resolve()
        let account = createAccount(context: persistence.viewContext)
        
        let vm = HOTPCodeViewModel()
        vm.setAccount(account: account)
        
        vm.generateCode(increment: false)

        let oldCode = vm.code
        let oldCounter = account.counter

        vm.generateCode(increment: true)
        
        XCTAssertNotEqual(vm.account?.counter, oldCounter)
        XCTAssertNotEqual(vm.code, oldCode)
    }
}
