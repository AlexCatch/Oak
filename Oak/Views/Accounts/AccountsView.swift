//
//  AccountsView.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI
import CoreData
import Resolver
import SwiftlySearch

struct AccountsView: View {
    @StateObject private var viewModel: AccountsViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.accountRowModels, id: \.id) {vm in
                        AccountRow(viewModel: vm, editAccountCallback: viewModel.editAccount)
                            .alert(isPresented: $viewModel.isDeleting) {
                                Alert(
                                    title: Text("Delete"),
                                    message: Text("Are you sure you want to delete this account? This cannot be undone so please make sure you've backed up your secret elsewhere"),
                                    primaryButton: .destructive(Text("Delete"), action: viewModel.confirmDeletion),
                                    secondaryButton: .cancel(Text("Cancel"), action: viewModel.cancelDeletion)
                                )
                            }
                    }
                    .onMove(perform: viewModel.move)
                    .onDelete(perform: viewModel.delete)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarSearch($viewModel.searchText, placeholder: "Search", hidesNavigationBarDuringPresentation: false)
                .onChange(of: viewModel.searchText, perform: viewModel.performQuery)
            }
            .navigationBarItems(leading: EditButton(), trailing: HStack {
                Button(action: {
                    viewModel.navigate(to: .settings)
                }, label: {
                    Image(systemName: "gear")
                })
                .accessibility(identifier: "SettingsButton")
                Button(action: {
                    viewModel.activeActionSheet = .add
                }, label: {
                    Image(systemName: "plus")
                })
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
