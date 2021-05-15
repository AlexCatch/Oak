//
//  ICloudToggableRow.swift
//  Oak
//
//  Created by Alex Catchpole on 15/05/2021.
//

import SwiftUI
import Resolver

struct ICloudToggableRow: View {
    var title: String
    var key: SettingsKey
    
    @Injected private var iCloudSettings: ICloudSettings
    @Injected private var persistence: PersistentStore
    
    init(title: String, key: SettingsKey) {
        self.title = title
        self.key = key
    }
    
    var body: some View {
        ToggableRow(title: title, key: key, settings: iCloudSettings) { toggled in
            persistence.toggleICloudSync(sync: toggled)
            
            if !toggled {
                persistence.deleteUserAccounts()
            }
        }
    }
}
