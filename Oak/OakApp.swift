//
//  OakApp.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Resolver

@main
struct OakApp: App {
    
    @Injected private var persistentStore: PersistentStore
    @Injected private var iCloudSettings: ICloudSettings;
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        // If we've failed to delete our store after requesting, let's attempt to delete
        if iCloudSettings.bool(key: .failedToDeleteZone) {
            persistentStore.deleteUserAccounts()
            iCloudSettings.set(key: .failedToDeleteZone, value: false)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView().environment(\.managedObjectContext, persistentStore.viewContext)
        }
    }
}
