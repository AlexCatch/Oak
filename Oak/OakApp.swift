//
//  OakApp.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Dependencies
import SwiftData
import ComposableArchitecture

enum RootView {
    case setup
    case accounts
}

@main
struct OakApp: App {
    @Dependency(\.database) var database
    let store: StoreOf<AppFeature>
    
    init() {
        @Dependency(\.settings) var settings
        let isSetup = settings.bool(forKey: .isSetup) ?? false
        store = Store(initialState: isSetup ? AppFeature.State.accounts(.init()) : AppFeature.State.setup(.init())) {
            AppFeature.body._printChanges()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
                .navigationViewStyle(StackNavigationViewStyle())
                .modelContainer(database.modelContainer)
        }
    }
}
