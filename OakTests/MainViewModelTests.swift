//
//  MainViewModelTests.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import Resolver
@testable import Oak

class MainViewModelTests: OakTestCase {
    func testSetInitialActiveView() {
        let settings: Settings = Resolver.resolve()
        settings.set(key: .isSetup, value: true)
        settings.set(key: .requireAuthOnStart, value: true)
        
        var vm = MainViewModel()
        XCTAssert(vm.activeView == .auth)
        
        settings.set(key: .requireAuthOnStart, value: false)
        vm = MainViewModel()
        XCTAssert(vm.activeView == .accounts)
        
        settings.set(key: .isSetup, value: false)
        vm = MainViewModel()
        XCTAssert(vm.activeView == .setup)
    }
}
