//
//  AuthenticationViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import Resolver
@testable import Oak

class AuthenticationViewModelTests: OakTestCase {
    func testAuthenticatePassword() {
        let keychainService: KeychainService = Resolver.resolve()
        keychainService.set(key: .password, value: "test123")
        
        let vm = AuthenticationViewModel()
        vm.password = "test123"
        XCTAssertTrue(vm.authenticatePassword())
    }
    
    func testAuthenticatePasswordInvalid() {
        let keychainService: KeychainService = Resolver.resolve()
        keychainService.set(key: .password, value: "test123")
        
        let vm = AuthenticationViewModel()
        vm.password = "test1234"
        XCTAssertFalse(vm.authenticatePassword())
    }
    
    func testPasswordValid() {
        let vm = AuthenticationViewModel()
        XCTAssertFalse(vm.passwordValid)
        
        vm.password = "test123"
        XCTAssertTrue(vm.passwordValid)
    }
}
