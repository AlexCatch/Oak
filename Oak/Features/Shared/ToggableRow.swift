//
//  ToggableRow.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Combine
import Dependencies

struct ToggableRow: View {
    var title: String
    var key: String
    var onChangeCallback: ((_ status: Bool) -> Void)?
    
    @ObservationIgnored
    @Dependency(\.settings) var settings: Settings
    
    @State private var isOn: Bool = false
    
    init(title: String, key: String, initialValue: Bool, onChange: ((_ status: Bool) -> Void)? = nil) {
        self.title = title
        self.key = key
        _isOn = State(initialValue: initialValue)
        
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
        .accessibility(identifier: "\(key)Switch")
        .onChange(of: isOn, perform: { value in
            self.onChangeCallback?(value)
        })
    }
}

//struct ToggableRow_Previews: PreviewProvider {
//    static var previews: some View {
////        ToggableRow(title: "Face ID or Touch ID", key: .biometricsEnabled)
//    }
//}
