//
//  UpdatePasswordViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import Resolver
@testable import Oak

class UpdatePasswordViewModelTests: OakTestCase {
    func testInputsAreValid() {
        let vm = UpdatePasswordViewModel()
        vm.enteredCurrentPassword = "test123"
        vm.newPassword = "test"
        vm.newPasswordConfirm = "test"
        XCTAssertTrue(vm.inputsAreValid)
    }
    
    func testInputsAreInvalid() {
        let vm = UpdatePasswordViewModel()
        vm.enteredCurrentPassword = "test123"
        vm.newPassword = "test"
        vm.newPasswordConfirm = "test123"
        XCTAssertFalse(vm.inputsAreValid)
        
        vm.newPassword = "test123"
        vm.enteredCurrentPassword = ""
        XCTAssertFalse(vm.inputsAreValid)
    }
    
    func testSaveChanges() {
        let keychainService: KeychainService = Resolver.resolve()
        keychainService.set(key: .password, value: "test123")
        
        let vm = UpdatePasswordViewModel()
        vm.enteredCurrentPassword = "test123"
        vm.newPassword = "test"
        
        vm.saveChanges {}
        
        XCTAssertEqual(keychainService.get(key: .password), "test")
    }
    
    func testSaveChangesFailure() {
        let keychainService: KeychainService = Resolver.resolve()
        keychainService.set(key: .password, value: "test123")
        
        let vm = UpdatePasswordViewModel()
        vm.enteredCurrentPassword = "test"
        vm.newPassword = "newPassword"
        
        vm.saveChanges {}
        
        XCTAssertEqual(keychainService.get(key: .password), "test123")
        XCTAssertNotNil(vm.updatePasswordError)
    }
}
