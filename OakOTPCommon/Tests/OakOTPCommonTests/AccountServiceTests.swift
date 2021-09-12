import XCTest
import Resolver
@testable import OakOTPCommon

class InitalFetchSpy: AccountServiceDelegate {
    let expectedAccounts: [Account]
    
    var accountsChangedCalled = false
    
    init(expectedAccounts: [Account]) {
        self.expectedAccounts = expectedAccounts
    }
    
    func accountsChanged(accounts: [Account]) {
        accountsChangedCalled = true
        XCTAssertEqual(accounts.count, expectedAccounts.count)
    }
}

class FilterSpy: AccountServiceDelegate {
    var expectedAccounts: [Account]
    var hasFiltered = false
    
    init(expectedAccounts: [Account]) {
        self.expectedAccounts = expectedAccounts
    }
    
    func accountsChanged(accounts: [Account]) {
        XCTAssertEqual(accounts.count, expectedAccounts.count)
        
        if hasFiltered {
            XCTAssertEqual(accounts, expectedAccounts)
        }
    }
}

final class AccountServiceTests: OakOTPCommonTestCase {
    
    /**
     Scope for our mocked persistent store is shared
     so to keep the same instance between our test and our account service
     we need to keep a reference here
     */
    var persistent: PersistentStore!

    override func setUp() {
        super.setUp()
        persistent = Resolver.resolve(PersistentStore.self, name: nil, args: nil)
    }

    override func tearDown() {
        super.tearDown()
        persistent = nil
    }
    
    private func createAccounts() throws -> [Account] {
        let persistent: PersistentStore = Resolver.resolve()
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
        
        try persistent.save()
        
        return [account1, account2]
    }
    
    func testInitialFetch() throws {
        let createdAccounts = try createAccounts()
        let service = RealAccountService()
        
        let initialFetchSpy = InitalFetchSpy(expectedAccounts: createdAccounts)
        service.delegate = initialFetchSpy
        
        XCTAssertTrue(initialFetchSpy.accountsChangedCalled)
    }
    
    func testFilter() throws {
        let createdAccounts = try createAccounts()
        let service = RealAccountService()
        
        let filterSpy = FilterSpy(expectedAccounts: createdAccounts)
        service.delegate = filterSpy
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR issuer CONTAINS[cd] %@", "Facebook", "Facebook")
        filterSpy.expectedAccounts = [createdAccounts.last!]
        filterSpy.hasFiltered = true
        try service.filter(predicate: predicate)
        
    }
}
