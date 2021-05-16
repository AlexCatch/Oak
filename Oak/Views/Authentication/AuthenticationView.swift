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
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Authenticaton")
            .navigationBarItems(trailing: Button("Unlock", action: {
                if viewModel.authenticatePassword() {
                    activeSheet = .accounts
                }
            }))
        }.onAppear {
            viewModel.rootViewBinding = $activeSheet
            viewModel.attemptBiometrics(for: scenePhase)
        }
    }
}
