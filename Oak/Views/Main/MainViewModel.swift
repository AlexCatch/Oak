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
    private let keychainService: KeychainService
    
    @Published var activeView: RootView = .Auth
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
        
        if keychainService.get(key: .Password) == nil {
            activeView = .Setup
        } else {
            activeView = settings.bool(key: .requireAuthOnStart) ? .Auth : .Accounts
        }
    }
}

extension Resolver {
    static func RegisterMainViewModel() {
        register { MainViewModel(keychainService: resolve()) }
    }
}
