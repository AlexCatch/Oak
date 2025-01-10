//
//  OakApp.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Dependencies
import SwiftData

enum RootView {
    case setup
    case accounts
}

@main
struct OakApp: App {
    @Dependency(\.modelManager) private var modelManager: ModelManager
    @Dependency(\.window) var window
    @Dependency(\.settings) var settings
    
    @State private var activeView: RootView = .setup
    
    init() {
        let isSetup = settings.bool(forKey: .isSetup) ?? false
        if isSetup {
            _activeView = State(initialValue: RootView.accounts)
        } else {
            activeView = .setup
        }
    }
    
    var rootView: some View {
        switch activeView {
        case .setup:
            return AnyView(SetupView(activeSheet: $activeView))
        case .accounts:
            return AnyView(AccountsView())
        }
    }
    
    var body: some Scene {
        WindowGroup {
            rootView
                .navigationViewStyle(StackNavigationViewStyle())
                .modelContainer(modelManager.modelContainer)
        }
    }
}
