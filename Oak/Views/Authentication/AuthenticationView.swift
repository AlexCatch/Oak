//
//  AuthenticationView.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI

struct AuthenticationView: View {
    @State private var password: String = ""
    
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Enter your password to unlock oak")) {
                    SecureField("Password", text: $password)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Authenticaton")
            .navigationBarItems(trailing: Button("Unlock", action: {
                // ask vm if password is legit
                Haptics.Generate(type: .success)
                withAnimation {
                    isAuthenticated = true
                }
            }))
        }.onAppear {
            Biometrics().authenticate {
                Haptics.Generate(type: .success)
                isAuthenticated = true
            } onFailure: {
        
            }

        }
    }
}
