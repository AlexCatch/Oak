//
//  AccountsViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
@testable import OakOTP
import Resolver

class AccountsViewModelTests: OakTestCase {
    var accounts: [Account] = []
    
    private func createAccounts() -> [Account] {
        let persistent: PersistentStore = Resolver.test.resolve()
        let account1 = Account(context: persistent.viewContext)
        account1.issuer = "Google"
        account1.name = "john@doe.co.uk"
        account1.secret = "helloworld"
        account1.algorithm = .sha1
        account1.type = .totp
        account1.createdAt = Date()
        account1.digits = Int16(6)
        account1.period = Int16(30)
        
        let account2 = Account(context: persistent.viewContext)
        account2.issuer = "Facebook"
        account2.name = "john@doe.co.uk"
        account2.secret = "helloworld123"
        account2.algorithm = .sha1
        account2.type = .totp
        account2.createdAt = Date()
        account2.digits = Int16(6)
        account2.period = Int16(30)
        
        return [account1, account2]
    }
    
    func testPopulateAccountRowViewModels() {
        let vm = AccountsViewModel()
        let accounts = createAccounts()
        
        vm.accountsChanged(accounts: accounts)
        
        XCTAssert(vm.accountRowModels.count == accounts.count)
    }
    
    func testEditAccount() {
        let vm = AccountsViewModel()
        let accounts = createAccounts()
        
        vm.accountsChanged(accounts: accounts)
        vm.editAccount(account: accounts[0])
        
        XCTAssert(vm.selectedAccountIndex == 0)
        XCTAssert(vm.activeSheet == .newAccount)
        XCTAssert(vm.selectedAccount == accounts[0])
    }
    
    func testConfirmDeletion() {
        let vm = AccountsViewModel()
        let accountService: AccountService = Resolver.resolve()
        
        let accounts = createAccounts()
        
        vm.accountsChanged(accounts: accounts)
        vm.delete(at: IndexSet([0]))
        vm.confirmDeletion()
        
        let fetchedAccounts = accountService.fetchAll()
        XCTAssertEqual(fetchedAccounts.count, 1)
        XCTAssertEqual(vm.accountRowModels.count, 1)
        XCTAssertFalse(vm.isDeleting)
        XCTAssertNil(vm.accountRowToDelete)
        XCTAssertNil(vm.accountRowToDeleteIndex)
    }
    
    func testCancelDeletion() {
        let vm = AccountsViewModel()
        let accountService: AccountService = Resolver.resolve()
        
        let accounts = createAccounts()
        
        vm.accountsChanged(accounts: accounts)
        vm.delete(at: IndexSet([0]))
        vm.cancelDeletion()
        
        let fetchedAccounts = accountService.fetchAll()
        XCTAssertEqual(fetchedAccounts.count, 2)
        XCTAssertEqual(vm.accountRowModels.count, 2)
        XCTAssertFalse(vm.isDeleting)
        XCTAssertNil(vm.accountRowToDelete)
        XCTAssertNil(vm.accountRowToDeleteIndex)
    }
    
    func testMove() {
        let vm = AccountsViewModel()
        let accountService: AccountService = Resolver.resolve()
        
        let accounts = createAccounts()
        
        vm.accountsChanged(accounts: accounts)
        
        // Check sure our accounts have switched
        XCTAssertEqual(vm.accountRowModels[0].account.issuer, "Google")
        XCTAssertEqual(vm.accountRowModels[1].account.issuer, "Facebook")
        
        vm.move(source: IndexSet([0]), destination: 2)
        
        // Check sure our accounts have switched
        XCTAssertEqual(vm.accountRowModels[0].account.issuer, "Facebook")
        XCTAssertEqual(vm.accountRowModels[1].account.issuer, "Google")
    }
}
