//
//  ChangePasswordUITests.swift
//  OakOTPUITests
//
//  Created by Alex Catchpole on 20/05/2021.
//

import XCTest

import XCTest

class ChangePasswordUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testChangePasswordSucceedsWithCorrectCurrentPassword() {
        let app = XCUIApplication()
        
        // Updated password to use and check against
        let newPassword = "updated"
        
        // Set password
        setup(with: app)
        
        // Update password
        app.buttons["SettingsButton"].tap()
        app.buttons["ChangePasswordButton"].tap()
        
        updatePassword(with: app, currentPassword: "test123", newPassword: newPassword, confirmPassword: newPassword)
        
        // Re-launch and test auth with new password
        app.terminate()
        app.launchArguments = ["-isSetup", "YES", "-requireAuthOnStart", "YES", "-biometricsEnabled", "NO"]
        app.activate()
        
        XCTAssert(app.secureTextFields["EnterPasswordSecureField"].waitForExistence(timeout: 5))
        app.secureTextFields["EnterPasswordSecureField"].tap()
        app.secureTextFields["EnterPasswordSecureField"].typeText(newPassword)
        
        app.buttons["UnlockButton"].tap()
        XCTAssert(app.staticTexts["Accounts"].exists)
    }
    
    func testChangePasswordFailsWithIncorrectCurrentPassword() {
        let app = XCUIApplication()
        
        // Set password
        setup(with: app)
        
        // Update password
        app.buttons["SettingsButton"].tap()
        app.buttons["ChangePasswordButton"].tap()

        updatePassword(with: app, currentPassword: "test1234", newPassword: "updated", confirmPassword: "updated")

        XCTAssert(app.alerts.element.staticTexts["Error"].exists)
    }
    
    func testChangePasswordConfirmButtonDisabled() {
        let app = XCUIApplication()
        
        // Set password
        setup(with: app)
        
        // Update password
        app.buttons["SettingsButton"].tap()
        app.buttons["ChangePasswordButton"].tap()
        
        updatePassword(with: app, currentPassword: "test123", newPassword: "updated", confirmPassword: "updated123")
        
        XCTAssertFalse(app.buttons["ConfirmButton"].isEnabled)
    }
    
    private func updatePassword(with app: XCUIApplication, currentPassword: String, newPassword: String, confirmPassword: String) {
        app.secureTextFields["CurrentPasswordSecureField"].tap()
        app.secureTextFields["CurrentPasswordSecureField"].typeText(currentPassword)
        
        app.secureTextFields["NewPasswordSecureField"].tap()
        app.secureTextFields["NewPasswordSecureField"].typeText(newPassword)
        
        app.secureTextFields["NewPasswordConfirmSecureField"].tap()
        app.secureTextFields["NewPasswordConfirmSecureField"].typeText(confirmPassword)
        
        if app.buttons["ConfirmButton"].isEnabled {
            app.buttons["ConfirmButton"].tap()
        }
    }
    
    private func setup(with app: XCUIApplication) {
        app.launchArguments = ["-isSetup", "NO"]
        app.launch()
        
        let passwordSecureField = app.secureTextFields["PasswordSecureField"]
        let passwordConfirmationSecureField = app.secureTextFields["PasswordConfirmationSecureField"]
        
        passwordSecureField.tap()
        passwordSecureField.typeText("test123")
        
        passwordConfirmationSecureField.tap()
        passwordConfirmationSecureField.typeText("test123")
        
        app.buttons["ConfirmButton"].tap()
    }
}
