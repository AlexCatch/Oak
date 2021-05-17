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
        XCTAssert(app.staticTexts["Authenticaton"].exists)
        
    }

}
