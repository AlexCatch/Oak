import XCTest
@testable import OakOTPCommon

final class OakOTPCommonTests: XCTestCase {
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
}
