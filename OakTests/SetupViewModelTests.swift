//
//  SetupViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import SwiftUI
import Resolver
import OakOTPCommon
@testable import OakOTP

class SetupViewModelTests: OakTestCase {
    
    func testInputsAreValidIfGivenCorrectData() {
        let vm = SetupViewModel()
        vm.password = "test123"
        vm.passwordConfirmation = "test123"
        XCTAssert(vm.areInputsValid)
    }

    func testInputsAreInvalidIfGivenBadData() {
        let vm = SetupViewModel()
        vm.password = "test1234"
        vm.passwordConfirmation = "test123"
        XCTAssert(!vm.areInputsValid)
        
        vm.password = ""
        vm.passwordConfirmation = ""
        XCTAssert(!vm.areInputsValid)
    }
    
    func testSetupWillRunCorrectly() {
        let vm = SetupViewModel()
        vm.password = "test123"
        vm.setup()
        
        // Get reference to our shared settings and keychain services
        let keychainService: KeychainService = Resolver.test.resolve()
        let settings: Settings = Resolver.test.resolve()
        
        XCTAssert(settings.bool(key: .isSetup))
        XCTAssert(keychainService.get(key: .password) == "test123")
    }

}
