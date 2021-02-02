//
//  OakApp.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

@main
struct OakApp: App {
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("AccentColor"))
    }
    
    var body: some Scene {
        let vm = AccountsViewModel(
            otpService:RealOTPService(),
            accountService: RealAccountService(dbRepository: RealAccountsDBRepository())
        )
        WindowGroup {
            ContentView(viewModel: vm)
        }
    }
}
