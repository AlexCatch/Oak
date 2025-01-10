//
//  SetupView.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import SwiftUI
import Dependencies

struct SetupView: View {
    @Dependency(\.biometrics) private var biometrics
    @Dependency(\.keychainService) private var keychain
    @Dependency(\.settings) private var settings
    @Dependency(\.iCloudSettings) private var iCloudSettings
    @Dependency(\.modelManager) private var model
    
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var requireAuth: Bool = true
    @State private var useBiometrics: Bool = false
    @State private var iCloudEnabled: Bool = false
    
    @Binding public var activeSheet: RootView
    
    init(activeSheet: Binding<RootView>) {
        _activeSheet = activeSheet
        _iCloudEnabled = State(initialValue: iCloudSettings.bool(forKey: .iCloudEnabled) ?? false)
    }
    
    var areInputsValid: Bool {
        return
            !password.isEmpty &&
            !passwordConfirmation.isEmpty &&
            password == passwordConfirmation
    }
    
    func setup() {
        iCloudSettings.set(iCloudEnabled, forKey: .iCloudEnabled)
        model.setupContainer(sync: iCloudEnabled)
        
        keychain.set(.password, password)
        settings.set(true, forKey: .isSetup)
        
        activeSheet = .accounts
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    footer: Text("Please write your password down somewhere safe - it can't be reset and if you forget it you won't be able to access your codes.")
                ) {
                    SecureField("Password", text: $password)
                        .accessibility(identifier: "PasswordSecureField")
                    SecureField("Confirm password", text: $passwordConfirmation)
                        .accessibility(identifier: "PasswordConfirmationSecureField")
                }
                Section(footer: Text("Authentication will be required when you launch or switch to the app")) {
                    Toggle("Require on start", isOn: $requireAuth)
                    Toggle("Face ID or Touch ID", isOn: $useBiometrics).isHidden(!biometrics.enabled(), remove: true)
                }
                Section(footer: Text("Your accounts will automatically be backed up and synced across all devices using the same iCloud account")) {
                    Toggle("Sync with iCloud", isOn: $iCloudEnabled)
                }
            }.contentMargins(.top, 18)
            .navigationTitle("Setup")
            .navigationBarItems(trailing:Button("Confirm", action: {
                setup()
            }).accessibility(identifier: "ConfirmButton").disabled(!areInputsValid))
        }
    }
}
