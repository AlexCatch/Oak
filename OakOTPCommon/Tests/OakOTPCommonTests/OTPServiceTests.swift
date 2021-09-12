import XCTest
import Resolver
@testable import OakOTPCommon

final class OTPServiceTests: OakOTPCommonTestCase {
    
    private func createTOTPAccount() throws -> Account {
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
    
        try persistent.save()
        
        return account1
    }
    
    func testTOTPBasicParseURISuccess() throws {
        let testString = "otpauth://totp/alex%40alexcatchpoledev.me?secret=helloworld&issuer=Github"
        let service = RealOTPService()
        
        let parsedURI = try service.parseSetupURI(uri: testString)
        XCTAssertEqual(parsedURI.issuer, "Github")
        XCTAssertEqual(parsedURI.secret, "helloworld")
        XCTAssertEqual(parsedURI.username, "alex@alexcatchpoledev.me")
        XCTAssertEqual(parsedURI.algorithm, .sha1)
        XCTAssertEqual(parsedURI.type, .totp)
        XCTAssertNil(parsedURI.counter)
        XCTAssertNil(parsedURI.period)
    }
    
    func testTOTPAdvancedParseURISuccess() throws {
        let testString = "otpauth://totp/alex%40alexcatchpoledev.me?secret=helloworld&issuer=Github&algorithm=SHA256&digits=8&period=60"
        let service = RealOTPService()
        
        let parsedURI = try service.parseSetupURI(uri: testString)
        XCTAssertEqual(parsedURI.issuer, "Github")
        XCTAssertEqual(parsedURI.secret, "helloworld")
        XCTAssertEqual(parsedURI.username, "alex@alexcatchpoledev.me")
        XCTAssertEqual(parsedURI.algorithm, .sha256)
        XCTAssertEqual(parsedURI.type, .totp)
        XCTAssertEqual(parsedURI.period, "60")
        XCTAssertEqual(parsedURI.digits, "8")
        
        XCTAssertNil(parsedURI.counter)
    }
    
    func testHOTPBasicParseURISuccess() throws {
        let testString = "otpauth://hotp/alex%40alexcatchpoledev.me?secret=helloworld&issuer=Github&counter=0"
        let service = RealOTPService()
        
        let parsedURI = try service.parseSetupURI(uri: testString)
        XCTAssertEqual(parsedURI.issuer, "Github")
        XCTAssertEqual(parsedURI.secret, "helloworld")
        XCTAssertEqual(parsedURI.username, "alex@alexcatchpoledev.me")
        XCTAssertEqual(parsedURI.algorithm, .sha1)
        XCTAssertEqual(parsedURI.type, .hotp)
        XCTAssertEqual(parsedURI.counter, "0")
        
        XCTAssertNil(parsedURI.period)
    }
    
    func testHOTPAdvancedParseURISuccess() throws {
        let testString = "otpauth://hotp/alex%40alexcatchpoledev.me?secret=helloworld&issuer=Github&counter=5&algorithm=SHA256&digits=8"
        let service = RealOTPService()
        
        let parsedURI = try service.parseSetupURI(uri: testString)
        XCTAssertEqual(parsedURI.issuer, "Github")
        XCTAssertEqual(parsedURI.secret, "helloworld")
        XCTAssertEqual(parsedURI.username, "alex@alexcatchpoledev.me")
        XCTAssertEqual(parsedURI.algorithm, .sha256)
        XCTAssertEqual(parsedURI.type, .hotp)
        XCTAssertEqual(parsedURI.counter, "5")
        
        XCTAssertNil(parsedURI.period)
    }
    
    func testTOTPCodeGeneration() throws {
        let service = RealOTPService()
        let account = try createTOTPAccount()
        
        let date = Date(timeIntervalSinceReferenceDate: 653070472.957172)
        let rightCodeForDate = "518279"
        let code = try service.generateCode(account: account, date: date)
        
        XCTAssertEqual(code, rightCodeForDate)
    }
}
