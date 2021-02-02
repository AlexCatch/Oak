//
//  SettingsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import Resolver

class SettingsViewModel: ObservableObject {
    enum Sheet: Identifiable {
        case editAccounts
        case updatePassword
        
        var id: Int {
            hashValue
        }
    }
    
    @Published var activeSheet: Sheet?
    
    func navigate(sheet: Sheet) {
        activeSheet = sheet
    }
}

extension Resolver {
    static func RegisterSettingsViewModel() {
        register { SettingsViewModel() }
    }
}
