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
                viewModel.authenticatePassword(with: $activeSheet)
            }))
        }.onAppear {
            viewModel.attemptBiometrics(with: $activeSheet)
        }
    }
}
