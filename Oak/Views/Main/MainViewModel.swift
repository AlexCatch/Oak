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
    private let keychainService: KeychainService
    
    @Published var activeView: RootView
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
        
        if keychainService.get(key: .Password) == nil {
            activeView = .Setup
        } else {
            activeView = Settings.bool(key: .requireAuthOnStart) ? .Auth : .Accounts
        }
    }
}

extension Resolver {
    static func RegisterMainViewModel() {
        register { MainViewModel(keychainService: resolve()) }
    }
}
