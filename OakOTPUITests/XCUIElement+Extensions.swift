//
//  XCUIElement+Extensions.swift
//  OakUITests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest

extension XCUIElement {
    
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        // workaround for apple bug
        if let placeholderString = self.placeholderValue, placeholderString == stringValue {
            return
        }
        
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        self.typeText(deleteString)
    }
    
    func tapUnhittable() {
        XCTContext.runActivity(named: "Tap \(self) by coordinate") { _ in
            coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)).tap()
        }
    }
}
