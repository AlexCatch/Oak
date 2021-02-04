//
//  MainViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver

enum RootView {
    case Setup
    case Auth
    case Accounts
}

class MainViewModel: ObservableObject {
    @Injected private var settings: Settings
    @Injected private var window: Window
    
    private let keychainService: KeychainService
    
    @Published var activeView: RootView = .Auth
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
        
        if keychainService.get(key: .Password) == nil {
            activeView = .Setup
        } else {
            activeView = settings.bool(key: .requireAuthOnStart) ? .Auth : .Accounts
        }
        
        // Add app lifecycle events to the main view
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationDidEnterBackgroundNotification() {
        print("application will resign")
        // If we require auth on startup - go back to auth
        guard settings.bool(key: .requireAuthOnStart) else {
            return
        }
        
        // Before we switch our view - we need to dismiss all open sheets
        window.dismissAllSheets(animated: false)
        activeView = .Auth
    }
}

extension Resolver {
    static func RegisterMainViewModel() {
        register { MainViewModel(keychainService: resolve()) }
    }
}
