//
//  MainView.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            AccountsView(viewModel: AccountsViewModel(
                otpService:RealOTPService(),
                accountService: RealAccountService(dbRepository: RealAccountsDBRepository())
            )).transition(.slide)
        } else {
            AuthenticationView(isAuthenticated: $isAuthenticated)
        }
    }
}
