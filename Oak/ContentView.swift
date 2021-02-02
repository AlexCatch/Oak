//
//  ContentView.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import CoreData
import CodeScanner

struct ContentView: View {
    @StateObject private var viewModel: AccountsViewModel
    
    init(viewModel: AccountsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.accountRowModels) { account in
                    AccountRow(viewModel: account)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    
                    viewModel.activeSheet = .settings
                }, label: {
                    Image(systemName: "gear")
                })
                Button(action: {
                    
                    viewModel.activeActionSheet = .add
                }, label: {
                    Image(systemName: "plus")
                })
            })
            .navigationTitle("Accounts")
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(item: $viewModel.activeSheet) { item in
                switch item {
                case .codeScanner:
                    ScanQRCodeView(onScan: viewModel.addFromQRCode)
                case .settings:
                    SettingsView(vm: SettingsViewModel())
                }
            }
            .actionSheet(item: $viewModel.activeActionSheet) { item in
                switch item {
                case .add:
                    return ActionSheet(title: Text("New Account"), buttons: [
                        .default(Text("Scan QR Code")) { viewModel.activeSheet = .codeScanner },
                        .cancel()
                    ])
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let accountService = RealAccountService(dbRepository: RealAccountsDBRepository())
        let vm = AccountsViewModel(otpService: RealOTPService(), accountService: accountService)
        ContentView(viewModel: vm)
    }
}
