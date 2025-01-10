//
//  ICloudToggableRow.swift
//  Oak
//
//  Created by Alex Catchpole on 15/05/2021.
//

import SwiftUI
import Dependencies
import SwiftData

struct ICloudToggableRow: View {
    var title: String
    var key: SettingsKey
    
    @Dependency(\.modelManager) var modelManager: ModelManager
    @Dependency(\.iCloudSettings) var ICloudSettings: ICloudSettings
    
    let schema = Schema([
        Account.self,
    ])
    
    init(title: String, key: SettingsKey) {
        self.title = title
        self.key = key
    }
    
    var body: some View {
        ToggableRow(title: title, key: key.rawValue, initialValue: ICloudSettings.bool(forKey: key) ?? false) { toggled in
            modelManager.setupContainer(sync: toggled)
        }
    }
}
