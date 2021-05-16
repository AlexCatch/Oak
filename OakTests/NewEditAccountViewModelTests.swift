//
//  NewEditAccountViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import Resolver
import CoreData
@testable import Oak

class NewEditAccountViewModelTests: OakTestCase {
    private func createAccount(context: NSManagedObjectContext, type: CodeType = .totp) -> Account {
        let account = Account(context: context)
        account.issuer = "Google"
        account.name = "john@doe.co.uk"
        account.secret = "helloworld"
        account.algorithm = .sha1
        account.type = type
        account.usesBase32 = false
        account.createdAt = Date()
        account.digits = Int16(6)
        account.period = Int16(30)
        
        return account
    }
    
    func testTitleIsCorrect() {
        let persistence: PersistentStore = Resolver.resolve()
        let account = createAccount(context: persistence.viewContext)
        
        let vm = NewEditAccountViewModel()
        vm.setAccount(account: account)
        
        XCTAssert(vm.navigationTitle == "Edit Account")
        
        vm.setAccount(account: nil)
        XCTAssert(vm.navigationTitle == "New Account")
    }
    
    func testValuesGetProperlyPopulatedForAccount() {
        let persistence: PersistentStore = Resolver.resolve()
        let account = createAccount(context: persistence.viewContext)
        
        let vm = NewEditAccountViewModel()
        vm.setAccount(account: account)
        
        XCTAssertEqual(vm.name, account.name)
        XCTAssertEqual(vm.issuer, account.issuer)
        XCTAssertEqual(vm.secret, account.secret)
        XCTAssertEqual(vm.type, account.type)
        XCTAssertEqual(vm.base32Encoded, account.usesBase32)
        XCTAssertEqual(vm.algorithm, account.algorithm)
        XCTAssertEqual(Int16(vm.digits), account.digits)
        XCTAssertEqual(Int16(vm.period), account.period)
        XCTAssertEqual(Int16(vm.counter), account.counter)
    }
    
    func testUpdatingExistingAccount() {
        let persistence: PersistentStore = Resolver.resolve()
        let account = createAccount(context: persistence.viewContext)
        let accountService: AccountService = Resolver.resolve()
        
        let vm = NewEditAccountViewModel()
        vm.setAccount(account: account)
        
        vm.name = "updated"
        vm.issuer = "updated"
        vm.secret = "updated"
        vm.base32Encoded = false
        vm.type = .hotp
        vm.algorithm = .sha256
        vm.digits = 7
        vm.counter = 2
        
        vm.save()
        
        // Ensure existing account has been updated
        let updatedAccount = accountService.fetchAll().first
        XCTAssertNotNil(updatedAccount)
        
        XCTAssertEqual(updatedAccount?.name, "updated")
        XCTAssertEqual(updatedAccount?.issuer, "updated")
        XCTAssertEqual(updatedAccount?.secret, "updated")
        XCTAssertEqual(updatedAccount?.usesBase32, false)
        XCTAssertEqual(updatedAccount?.type, .hotp)
        XCTAssertEqual(updatedAccount?.algorithm, .sha256)
        XCTAssertEqual(updatedAccount?.digits, 7)
        XCTAssertEqual(updatedAccount?.counter, 2)
    }
    
    func testNewAccountTOTP() {
        let accountService: AccountService = Resolver.resolve()
        
        let vm = NewEditAccountViewModel()
        
        vm.name = "name"
        vm.issuer = "issuer"
        vm.secret = "secret"
        vm.base32Encoded = false
        vm.type = .totp
        vm.algorithm = .sha256
        vm.digits = 7
        vm.period = 29
        
        vm.save()
        
        // Ensure existing account has been updated
        let newAccount = accountService.fetchAll().first
        XCTAssertNotNil(newAccount)
        
        XCTAssertEqual(newAccount?.name, "name")
        XCTAssertEqual(newAccount?.issuer, "issuer")
        XCTAssertEqual(newAccount?.secret, "secret")
        XCTAssertEqual(newAccount?.usesBase32, false)
        XCTAssertEqual(newAccount?.type, .totp)
        XCTAssertEqual(newAccount?.algorithm, .sha256)
        XCTAssertEqual(newAccount?.digits, 7)
        XCTAssertEqual(newAccount?.period, 29)
    }
    
    func testNewAccountHOTP() {
        let accountService: AccountService = Resolver.resolve()
        
        let vm = NewEditAccountViewModel()
        
        vm.name = "name"
        vm.issuer = "issuer"
        vm.secret = "secret"
        vm.base32Encoded = false
        vm.type = .hotp
        vm.algorithm = .sha256
        vm.digits = 7
        vm.counter = 1
        
        vm.save()
        
        // Ensure existing account has been updated
        let newAccount = accountService.fetchAll().first
        XCTAssertNotNil(newAccount)
        
        XCTAssertEqual(newAccount?.name, "name")
        XCTAssertEqual(newAccount?.issuer, "issuer")
        XCTAssertEqual(newAccount?.secret, "secret")
        XCTAssertEqual(newAccount?.usesBase32, false)
        XCTAssertEqual(newAccount?.type, .hotp)
        XCTAssertEqual(newAccount?.algorithm, .sha256)
        XCTAssertEqual(newAccount?.digits, 7)
        XCTAssertEqual(newAccount?.counter, 1)
    }
    
    func testDeleteAccount() {
        let persistence: PersistentStore = Resolver.resolve()
        let account = createAccount(context: persistence.viewContext)
        let accountService: AccountService = Resolver.resolve()
        
        let vm = NewEditAccountViewModel()
        vm.setAccount(account: account)
        
        vm.confirmDeletion()
        
        let fetchedAccounts = accountService.fetchAll()
        XCTAssertEqual(fetchedAccounts.count, 0)
    }
}
