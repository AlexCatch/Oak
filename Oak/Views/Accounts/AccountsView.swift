//
//  AccountsView.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import CoreData
import CodeScanner
import Resolver

struct AccountsView: View {
    @StateObject private var viewModel: AccountsViewModel = Resolver.resolve()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.accountRowModels.indices, id: \.self) { index in
                    AccountRow(viewModel: viewModel.accountRowModels[index], editAccountCallback: viewModel.editAccount, index: index)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    viewModel.navigate(to: .settings)
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
                    ScanQRCodeView(dismiss: viewModel.hideSheet, didAddAccount: viewModel.didAddUpdateAccount)
                case .settings:
                    SettingsView(dismiss: viewModel.hideSheet)
                case .newAccount:
                    NewEditAccountView(dismiss: viewModel.hideSheet, account: viewModel.selectedAccount, didCreateUpdateAccount: viewModel.didAddUpdateAccount, didDeleteAccount: viewModel.didDeleteAccount)
                }
            }
            .actionSheet(item: $viewModel.activeActionSheet) { item in
                switch item {
                case .add:
                    return ActionSheet(title: Text("New Account"), buttons: [
                        .default(Text("Scan QR Code")) { viewModel.navigate(to: .codeScanner) },
                        .default(Text("Enter Information")) { viewModel.navigate(to: .newAccount) },
                        .cancel()
                    ])
                }
            }
            .onAppear {
                viewModel.fetchAccounts()
            }
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
