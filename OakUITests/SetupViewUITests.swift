//
//  SetupViewUITests.swift
//  OakUITests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest

class SetupViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testConfirmButtonStatus() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments += ["-isSetup", "NO"]
        app.launch()
        
        let passwordSecureField = app.secureTextFields["PasswordSecureField"]
        let passwordConfirmationSecureField = app.secureTextFields["PasswordConfirmationSecureField"]
        
        passwordSecureField.tap()
        passwordSecureField.typeText("test123")
        
        passwordConfirmationSecureField.tap()
        passwordConfirmationSecureField.typeText("test")
        
        XCTAssertFalse(app.buttons["ConfirmButton"].isEnabled)
        
        passwordConfirmationSecureField.clearText()
        passwordConfirmationSecureField.typeText("test123")
        XCTAssertTrue(app.buttons["ConfirmButton"].isEnabled)
    }
    
    func testPressingConfirmWillFinishSetup() {
        let app = XCUIApplication()
        app.launchArguments += ["-isSetup", "NO"]
        app.launch()
        
        let passwordSecureField = app.secureTextFields["PasswordSecureField"]
        let passwordConfirmationSecureField = app.secureTextFields["PasswordConfirmationSecureField"]
        
        passwordSecureField.tap()
        passwordSecureField.typeText("test123")
        
        passwordConfirmationSecureField.tap()
        passwordConfirmationSecureField.typeText("test123")
        
        app.buttons["ConfirmButton"].tap()
        
        XCTAssert(app.staticTexts["Accounts"].exists)
        
        app.terminate()
        app.launchArguments = ["-requireAuthOnStart", "NO"]
        app.launch()
        
        XCTAssert(app.staticTexts["Accounts"].exists)
    }
}
