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
                    ScanQRCodeView(onScan: viewModel.addAccount)
                case .settings:
                    SettingsView()
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
