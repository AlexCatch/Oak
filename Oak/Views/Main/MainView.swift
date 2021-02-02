//
//  MainView.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver

struct MainView: View {
    @StateObject private var mainViewModel: MainViewModel = Resolver.resolve()
    
    var body: some View {
        currentView()
    }
    
    func currentView() -> AnyView {
        switch mainViewModel.activeView {
        case .Setup:
            return AnyView(SetupView(activeSheet: $mainViewModel.activeView))
        case .Auth:
            return AnyView(AuthenticationView(activeSheet: $mainViewModel.activeView))
        case .Accounts:
            return AnyView(AccountsView())
        }
    }
}
