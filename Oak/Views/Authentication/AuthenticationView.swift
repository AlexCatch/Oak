//
//  AuthenticationView.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver

struct AuthenticationView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel: AuthenticationViewModel = Resolver.resolve()
    @Binding var activeSheet: RootView
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Enter your password to unlock oak")) {
                    SecureField("Password", text: $viewModel.password)
                        .accessibilityIdentifier("EnterPasswordSecureField")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Authentication")
            .navigationBarItems(trailing: Button("Unlock", action: {
                if viewModel.authenticatePassword() {
                    activeSheet = .accounts
                }
            }).accessibility(identifier: "UnlockButton"))
        }
        .alert(isPresented: $viewModel.authFailed) {
            Alert(title: Text("Incorrect Password"), message: Text("Please double check your password and try again."), dismissButton: .cancel())
        }
        .task {
            viewModel.rootViewBinding = $activeSheet
            await viewModel.attemptBiometrics(for: scenePhase)
        }
    }
}
