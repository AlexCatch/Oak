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
                List(viewModel.accountRowModels, id: \.id) { vm in
                    AccountRow(viewModel: vm, editAccountCallback: viewModel.editAccount)
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
            .sheet(item: $viewModel.activeSheet) { item in
                switch item {
                case .codeScanner:
                    ScanQRCodeView(dismiss: viewModel.hideSheet)
                case .settings:
                    SettingsView(dismiss: viewModel.hideSheet)
                case .newAccount:
                    NewEditAccountView(dismiss: viewModel.hideSheet, account: viewModel.selectedAccount)
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            UITableView.appearance().contentInset.top = 10
        }
        .onDisappear {
            UITableView.appearance().contentInset.top = 0
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
