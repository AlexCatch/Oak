import XCTest
import Resolver

class OakOTPCommonTestCase: XCTestCase {
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        Resolver.root = .test
    }
}
