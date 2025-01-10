//
//  SetupFeature.swift
//  OakOTP
//
//  Created by Alex on 10/01/2025.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SetupFeature {
    @ObservableState
    struct State: Equatable {
        var biometricsAvailable: Bool = false
        
        var password: String = ""
        var passwordConfirm: String = ""
        
        var requireAuthOnStartUp: Bool = true
        var biometricsEnabled: Bool = false
        var iCloudSyncEnabled: Bool = true
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case setup
    }
    
    @Dependency(\.biometrics) private var biometrics
    @Dependency(\.keychainService) private var keychain
    @Dependency(\.settings) private var settings
    @Dependency(\.iCloudSettings) private var iCloudSettings
    @Dependency(\.modelManager) private var model

    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .setup:
                return .run { [state] send in
                    iCloudSettings.set(state.iCloudSyncEnabled, forKey: .iCloudEnabled)
                    model.setupContainer(sync: state.iCloudSyncEnabled)
                    
                    keychain.set(.password, state.password)
                    settings.set(true, forKey: .isSetup)
                }
            case .binding:
                return .none
            }
        }
    }
}

struct SetupView: View {
    @Bindable var store: StoreOf<SetupFeature>
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    footer: Text("Please write your password down somewhere safe - it can't be reset and if you forget it you won't be able to access your codes.")
                ) {
                    SecureField("Password", text: $store.password)
                        .accessibility(identifier: "PasswordSecureField")
                    SecureField("Confirm password", text: $store.passwordConfirm)
                        .accessibility(identifier: "PasswordConfirmationSecureField")
                }
                Section(footer: Text("Authentication will be required when you launch or switch to the app")) {
                    Toggle("Require on start", isOn: $store.requireAuthOnStartUp)
                    Toggle("Face ID or Touch ID", isOn: $store.biometricsEnabled).isHidden(store.biometricsAvailable, remove: true)
                }
                Section(footer: Text("Your accounts will automatically be backed up and synced across all devices using the same iCloud account")) {
                    Toggle("Sync with iCloud", isOn: $store.iCloudSyncEnabled)
                }
            }
            .navigationTitle("Setup")
            .navigationBarItems(trailing:Button("Confirm", action: {
                store.send(.setup)
            }).accessibility(identifier: "ConfirmButton"))
        }
    }
}

#Preview {
    SetupView(store: Store(initialState: SetupFeature.State(), reducer: {
        SetupFeature()
    }, withDependencies: {
        $0.userDefaults = .ephemeral()
    }))
}
