//
//  AccountRowViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import Resolver
import CoreData
import OakOTPCommon
@testable import OakOTP

class AccountRowViewModelTests: OakTestCase {
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
    
    func testCopyCode() throws {
        let persistent: PersistentStore = Resolver.test.resolve()
    
        let account = createAccount(context: persistent.viewContext)
        let vm = AccountRowViewModel(account: account)
        
        UIPasteboard.general.string = ""
        
        vm.copyCode()
        
        XCTAssertTrue(vm.hasCopied)
        XCTAssertNotNil(UIPasteboard.general.string)
    }
}
