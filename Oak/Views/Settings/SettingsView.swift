//
//  SettingsView.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import Resolver

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = Resolver.resolve()
    
    let dismiss: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Authentication"), footer: Text("If you enable Require On Start, authentication will be required when you launch or switch to the app")) {
                    ToggableRow(title: "Require on start", key: .requireAuthOnStart)
                    ToggableRow(title: "Face ID or Touch ID", key: .biometricsEnabled)
                        .isHidden(!viewModel.biometricsEnabled, remove: true)
                }
                Section(header: Text("Sync"), footer: Text("If this option is enabled, your accounts will automatically be backed up and synced across all devices using the same account")) {
                    ICloudToggableRow(title: "iCloud", key: .iCloudEnabled)
                }
                Section(header: Text("Manage")) {
                    Button("Change Password") {
                        viewModel.navigate(sheet: .updatePassword)
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }, label: {
                Text("Done")
            }))
            .sheet(item: $viewModel.activeSheet) { item in
                switch item {
                case .updatePassword:
                    UpdatePasswordView(dismiss: viewModel.closeSheet)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView {}
    }
}
