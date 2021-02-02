//
//  SettingsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    enum Sheet: Identifiable {
        case editAccounts
        
        var id: Int {
            hashValue
        }
    }
    
    @Published var activeSheet: Sheet?
}
