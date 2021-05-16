//
//  OakTestCase.swift
//  OakTests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest
import Resolver

class OakTestCase: XCTestCase {
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        Resolver.root = .test
    }
}
