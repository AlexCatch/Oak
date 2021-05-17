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
        case updatePassword
        
        var id: Int {
            hashValue
        }
    }
    
    @Published var activeSheet: Sheet?
    @Published var biometricsEnabled = Biometrics().enabled()
    
    func navigate(sheet: Sheet) {
        activeSheet = sheet
    }
    
    func closeSheet() {
        activeSheet = nil
    }
}

extension Resolver {
    static func RegisterSettingsViewModel() {
        register { SettingsViewModel() }
    }
}
