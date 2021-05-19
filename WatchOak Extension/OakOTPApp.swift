//
//  OakOTPApp.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import SwiftUI

@main
struct OakOTPApp: App {
    init() {
        WatchSessionService.sharedManager.startSession()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AccountsView()
            }
        }
    }
}
