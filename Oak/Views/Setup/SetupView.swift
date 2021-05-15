//
//  SetupView.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import SwiftUI
import Resolver

struct SetupView: View {
    @StateObject private var viewModel: SetupViewModel = Resolver.resolve()
    @Binding var activeSheet: RootView
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    footer: Text("Please write your password down somewhere safe - it can't be reset and if you forget it you won't be able to access your codes.")
                ) {
                    SecureField("Password", text: $viewModel.password)
                    SecureField("Confirm Password", text: $viewModel.passwordConfirmation)
                }
                Section(footer: Text("If you enable Face ID or Touch ID, it will be required when you launch or switch to the app")) {
                    ToggableRow(title: "Require on Start", key: .requireAuthOnStart)
                    ToggableRow(title: "Face ID or Touch ID", key: .biometricsEnabled)
                }
                Section(footer: Text("If this option is enabled, your accounts will automatically be backed up and synced across all devices using the same iCloud account")) {
                    ICloudToggableRow(title: "iCloud", key: .iCloudEnabled)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Setup")
            .navigationBarItems(trailing:Button("Confirm", action: {
                // ask vm if password is legit
                viewModel.setup(with: $activeSheet)
            }).disabled(!viewModel.areInputsValid))
        }
    }
}
