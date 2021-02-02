//
//  SettingsView.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SettingsViewModel
    
    init(vm: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Security"), footer: Text("If you enable Face ID or Touch ID, it will be required when you launch or switch to the app")) {
                    ToggableRow(title: "Require on start", key: .requireAuthOnStart)
                    ToggableRow(title: "Face ID or Touch ID", key: .biometricsEnabled)
                }
                Section(header: Text("Sync"), footer: Text("If this option is enabled, your accounts will automatically be backed up and synced across all devices using the same account")) {
                    ToggableRow(title: "iCloud", key: .requireAuthOnStart)
                }
                Section(header: Text("Manage")) {
                    Button("Edit Accounts") {
                        viewModel.activeSheet = .editAccounts
                    }
                    Button("Change Password") {
                        viewModel.activeSheet = .editAccounts
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
            }))
            .sheet(item: $viewModel.activeSheet) { item in
                switch item {
                case .editAccounts:
                    EditAccounts(vm: EditAccountsViewModel(accountService: RealAccountService(dbRepository: RealAccountsDBRepository())))
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(vm: SettingsViewModel())
    }
}
