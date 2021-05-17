//
//  AuthenticationViewUITests.swift
//  OakUITests
//
//  Created by Alex Catchpole on 17/05/2021.
//

import XCTest

class AuthenticationViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testPasswordAuthenticationFailure() {
        let app = XCUIApplication()
        let password = "test123"
        
        setupAccount(with: app, password: password)
        
        let enterPasswordSecureField = app.secureTextFields["EnterPasswordSecureField"]
        enterPasswordSecureField.tap()
        enterPasswordSecureField.typeText("wrongpassword")
        
        app.buttons["UnlockButton"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["Incorrect Password"].exists)
        XCTAssertFalse(app.staticTexts["Accounts"].exists)
    }
    
    func testPasswordAuthenticationSuccess() {
        let app = XCUIApplication()
        let password = "test123"
        
        setupAccount(with: app, password: password)
        
        let enterPasswordSecureField = app.secureTextFields["EnterPasswordSecureField"]
        enterPasswordSecureField.tap()
        enterPasswordSecureField.typeText(password)
        
        app.buttons["UnlockButton"].tap()
        
        XCTAssert(app.staticTexts["Accounts"].exists)
    }
    
    func testAuthenticationBiometricsSuccess() {
        let app = XCUIApplication()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        launchWithBiometrics(on: app, with: springboard)
        Biometrics.successfulAuthentication()
        
        XCTAssertTrue(app.staticTexts["Accounts"].waitForExistence(timeout: 3))
    }
    
    func testAuthenticationBiometricsFailure() {
        let app = XCUIApplication()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        launchWithBiometrics(on: app, with: springboard)
        Biometrics.unsuccessfulAuthentication()
        
        let cancelButton = springboard.alerts.buttons["Cancel"].firstMatch
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Accounts"].exists)
    }
    
    private func setupAccount(with app: XCUIApplication, password: String) {
        app.launchArguments = ["-isSetup", "NO"]
        app.launch()
        
        let passwordSecureField = app.secureTextFields["PasswordSecureField"]
        let passwordConfirmationSecureField = app.secureTextFields["PasswordConfirmationSecureField"]
        
        passwordSecureField.tap()
        passwordSecureField.typeText(password)
        
        passwordConfirmationSecureField.tap()
        passwordConfirmationSecureField.typeText(password)
        
        app.buttons["ConfirmButton"].tap()
        
        XCTAssert(app.staticTexts["Accounts"].exists)
        
        app.terminate()
        app.launchArguments = ["-requireAuthOnStart", "YES", "-biometricsEnabled", "NO"]
        app.launch()
    }
    
    private func launchWithBiometrics(on app: XCUIApplication, with springboard: XCUIApplication) {
        Biometrics.enrolled()
        
        app.launchArguments = ["-isSetup", "YES", "-biometricsEnabled", "YES", "-requireAuthOnStart", "YES"]
        app.launch()
        
        acceptPermissionsPromptIfRequired(with: springboard)
    }
    
    private func acceptPermissionsPromptIfRequired(with springboard: XCUIApplication) {
        let permissionsOkayButton = springboard.alerts.buttons["OK"].firstMatch
        if permissionsOkayButton.exists {
            permissionsOkayButton.tap()
        }
    }
}
