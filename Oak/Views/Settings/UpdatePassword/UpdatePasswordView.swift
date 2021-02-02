//
//  UpdatePasswordView.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver

struct UpdatePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: UpdatePasswordViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Current Password")) {
                    SecureField("Password", text: $viewModel.enteredCurrentPassword)
                }
                Section(
                    header: Text("New Password"),
                    footer: Text("Please write your password down somewhere safe - it can't be reset and if you forget it you won't be able to access your codes.")
                ) {
                    SecureField("Password", text: $viewModel.newPassword)
                    SecureField("Confirm Password", text: $viewModel.newPasswordConfirm)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .alert(isPresented: viewModel.isPresentingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.updatePasswordError ?? ""),
                    dismissButton: .default(Text("Okay"))
                )
            }
            .navigationTitle("Change Password")
            .navigationBarItems(trailing:Button("Confirm", action: {
                if viewModel.saveChanges() {
                    presentationMode.wrappedValue.dismiss()
                }
            }).disabled(!viewModel.inputsAreValid))
        }
    }
}
