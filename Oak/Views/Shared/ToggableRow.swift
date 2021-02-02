//
//  ToggableRow.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Combine

struct ToggableRow: View {
    
    var title: String
    var key: SettingsKey
    
    @State private var isOn: Bool
    
    init(title: String, key: SettingsKey) {
        self.title = title
        self.key = key
        _isOn = State(initialValue: Settings.bool(key: key))
    }
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        .onReceive(Just(isOn)) { value in
            Settings.set(key: key, value: value)
        }
    }
}

struct ToggableRow_Previews: PreviewProvider {
    static var previews: some View {
        ToggableRow(title: "Face ID or Touch ID", key: .biometricsEnabled)
    }
}
