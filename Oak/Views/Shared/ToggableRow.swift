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
    var onChangeCallback: ((_ status: Bool) -> Void)?
    
    private var settings: Settings
    @State private var isOn: Bool = false
    
    init(title: String, key: SettingsKey, settings: Settings = Resolver.resolve(), onChange: ((_ status: Bool) -> Void)? = nil) {
        self.title = title
        self.key = key
        self.settings = settings
        _isOn = State(initialValue: settings.bool(key: key))
        
        self.onChangeCallback = onChange

    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle(isOn: $isOn) {
                Text(title)
            }
        }
        .labelsHidden()
        .accessibility(identifier: "\(key.rawValue)Switch")
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        .onChange(of: isOn, perform: { value in
            settings.set(key: key, value: value)
            self.onChangeCallback?(value)
        })
    }
}

struct ToggableRow_Previews: PreviewProvider {
    static var previews: some View {
        ToggableRow(title: "Face ID or Touch ID", key: .biometricsEnabled)
    }
}
