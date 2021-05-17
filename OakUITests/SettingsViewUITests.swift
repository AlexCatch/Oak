//
//  SettingsViewUITests.swift
//  OakUITests
//
//  Created by Alex Catchpole on 16/05/2021.
//

import XCTest

class SettingsViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testBiometricsAuthentationOptionIsHidden() {
        let app = XCUIApplication()
        app.launchArguments = ["-isSetup", "YES", "-requireAuthOnStart", "NO"]
        
        Biometrics.unenrolled()
        
        app.launch()
        app.buttons["SettingsButton"].tap()
        
        XCTAssertFalse(app.switches["biometricsEnabledSwitch"].exists)
    }
    
    func testBiometricsAuthentationOptionIsVisible() {
        let app = XCUIApplication()
        app.launchArguments = ["-isSetup", "YES", "-requireAuthOnStart", "NO"]
        
        Biometrics.enrolled()
        
        app.launch()
        app.buttons["SettingsButton"].tap()
        
        XCTAssert(app.switches["biometricsEnabledSwitch"].exists)
    }
    
    func testTogglingRequireAuthOnStartup() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-isSetup", "YES", "-requireAuthOnStart", "NO"]
        app.launch()
        
        // Open settings and toggle require auth on startup
        app.buttons["SettingsButton"].tap()
        app.switches["requireAuthOnStartSwitch"].tap()
        
        app.terminate()
        app.launchArguments = ["-isSetup", "YES"]
        app.launch()

        // Make sure we're on the auth screen
        XCTAssert(app.staticTexts["Authentication"].exists)
    }
    
    func testBiometricsEnabledTriggersBiometricAuth() {
        let app = XCUIApplication()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        app.launchArguments = ["-isSetup", "YES", "-requireAuthOnStart", "NO", "-biometricsEnabled", "NO"]
        app.launch()
        
        Biometrics.enrolled()
        
        app.buttons["SettingsButton"].tap()
        sleep(1)
        app.switches["biometricsEnabledSwitch"].tap()
        
        app.terminate()
        app.launchArguments = ["-isSetup", "YES", "-requireAuthOnStart", "YES"]
        app.launch()
        
        // We can't check for the face ID popup so we need to authenticate and then check result of that
        acceptPermissionsPromptIfRequired(with: springboard)
        Biometrics.successfulAuthentication()
        
        XCTAssertTrue(app.staticTexts["Accounts"].waitForExistence(timeout: 3))
    }
    
    private func acceptPermissionsPromptIfRequired(with springboard: XCUIApplication) {
        let permissionsOkayButton = springboard.alerts.buttons["OK"].firstMatch
        if permissionsOkayButton.exists {
            permissionsOkayButton.tap()
        }
    }
}
