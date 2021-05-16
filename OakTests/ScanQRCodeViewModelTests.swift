//
//  ScanQRCodeViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import SwiftUI
@testable import Oak
import CodeScanner
import Resolver

class ScanQRCodeViewModelTests: OakTestCase {
    
    func testOnSuccessfulScanTOTP() {
        let accountService: AccountService = Resolver.resolve()
        let result = Result<String, CodeScannerView.ScanError>.success("otpauth://totp/DropBox:jdoe@gmail.com?secret=VZL7MUKAT2N7ONO3GIQ3I3LZOMHNBCBL&issuer=DropBox&algorithm=SHA1&digits=6&period=30")
        
        let vm = ScanQRCodeViewModel()
        vm.onScan(results: result) {}
        
        let accounts = accountService.fetchAll()
        XCTAssertNotNil(accounts.first)
        
        let firstAccount = accounts.first!
        XCTAssert(firstAccount.issuer == "DropBox")
        XCTAssert(firstAccount.name == "jdoe@gmail.com")
        XCTAssert(firstAccount.secret == "VZL7MUKAT2N7ONO3GIQ3I3LZOMHNBCBL")
        XCTAssert(firstAccount.algorithm == .sha1)
        XCTAssert(firstAccount.digits == 6)
        XCTAssert(firstAccount.period == 30)
    
    }
    
    func testOnSuccessfulScanHOTP() {
        let accountService: AccountService = Resolver.resolve()
        let result = Result<String, CodeScannerView.ScanError>.success("otpauth://hotp/alexcatch?secret=helloworld&issuer=Github&counter=0")
        
        let vm = ScanQRCodeViewModel()
        vm.onScan(results: result) {}
        
        let accounts = accountService.fetchAll()
        XCTAssertNotNil(accounts.first)
        
        let firstAccount = accounts.first!
        XCTAssert(firstAccount.issuer == "Github")
        XCTAssert(firstAccount.name == "alexcatch")
        XCTAssert(firstAccount.secret == "helloworld")
        XCTAssert(firstAccount.algorithm == .sha1)
        XCTAssert(firstAccount.digits == 6)
        XCTAssert(firstAccount.counter == 0)
    }
    
    func testInvalidCodeScan() {
        let accountService: AccountService = Resolver.resolve()
        let result = Result<String, CodeScannerView.ScanError>.success("invalidURLHere")
        
        let vm = ScanQRCodeViewModel()
        vm.onScan(results: result) {}
        
        let accounts = accountService.fetchAll()
        XCTAssert(accounts.count == 0)
        XCTAssertNotNil(vm.scanError)
        XCTAssertTrue(vm.isPresentingAlert.wrappedValue)
    }
}
