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
    @StateObject private var viewModel: UpdatePasswordViewModel = Resolver.resolve()
    
    let dismiss: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Current Password")) {
                    SecureField("Password", text: $viewModel.enteredCurrentPassword)
                        .accessibility(identifier: "CurrentPasswordSecureField")
                }
                Section(
                    header: Text("New Password"),
                    footer: Text("Please write your password down somewhere safe - it can't be reset and if you forget it you won't be able to access your codes.")
                ) {
                    SecureField("Password", text: $viewModel.newPassword)
                        .accessibility(identifier: "NewPasswordSecureField")
                    SecureField("Confirm Password", text: $viewModel.newPasswordConfirm)
                        .accessibility(identifier: "NewPasswordConfirmSecureField")
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
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }, label: {
                Text("Dismiss")
            }), trailing:Button("Confirm", action: {
                viewModel.saveChanges(dismiss: dismiss)
            }).accessibility(identifier: "ConfirmButton").disabled(!viewModel.inputsAreValid))
        }
    }
}
