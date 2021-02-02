//
//  ToggableRow.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Combine
import Resolver

struct ToggableRow: View {
    var title: String
    var key: SettingsKey
    
    @Injected private var settings: Settings
    @State private var isOn: Bool = false
    
    init(title: String, key: SettingsKey) {
        self.title = title
        self.key = key
        _isOn = State(initialValue: settings.bool(key: key))
    }
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        .onReceive(Just(isOn)) { value in
            settings.set(key: key, value: value)
        }
    }
}

struct ToggableRow_Previews: PreviewProvider {
    static var previews: some View {
        ToggableRow(title: "Face ID or Touch ID", key: .biometricsEnabled)
    }
}
