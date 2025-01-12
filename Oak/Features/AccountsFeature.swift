//
//  AccountFeature.swift
//  OakOTP
//
//  Created by Alex on 11/01/2025.
//

import SwiftUI
import ComposableArchitecture

@CasePathable
enum Loadable<Entity> {
    case notAsked
    case loading
    case error(error: EquatableError)
    case result(Entity)
}

@Reducer
struct AccountsFeature {
    @ObservableState
    struct State {
        var accounts: Loadable<[Account]> = .notAsked
    }
    
    enum Action {
        case fetchAccounts
        case fetchedAccounts(Loadable<[Account]>)
    }
    
    @Dependency(\.accountService) var accountService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchAccounts:
                state.accounts = .loading
                return .run { send in
                    do {
                        let results = try await accountService.fetchAll()
                        await send(.fetchedAccounts(.result(results)))
                    } catch let error {
                        await send(.fetchedAccounts(.error(error: EquatableError(error))))
                    }
                }
            case .fetchedAccounts(let result):
                state.accounts = result
                return .none
            }
        }
    }
}

struct AccountsView: View {
    let store: StoreOf<AccountsFeature>
    
    init(store: StoreOf<AccountsFeature>) {
        self.store = store
        store.send(.fetchAccounts)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(store.accounts[case: \.result] ?? [], id: \.id) {account in
                        Text(account.name ?? "")
//                        AccountRow(viewModel: vm, editAccountCallback: {account in print("hello")})
//                            .alert(isPresented: .constant(false)) {
//                                Alert(
//                                    title: Text("Delete"),
//                                    message: Text("Are you sure you want to delete this account? This cannot be undone so please make sure you've backed up your secret elsewhere"),
//                                    primaryButton: .destructive(Text("Delete"), action: {}),
//                                    secondaryButton: .cancel(Text("Cancel"), action: {})
//                                )
//                            }
                    }
                    .onMove(perform: {_,_ in })
                    .onDelete(perform: {_ in })
                }
//                .navigationBarSearch({}, placeholder: "Search", hidesNavigationBarDuringPresentation: false)
                .onChange(of: "", perform: {newValue in })
            }
            .navigationBarItems(leading: EditButton(), trailing: HStack {
                Button(action: {
//                    viewModel.navigate(to: .settings)
                }, label: {
                    Image(systemName: "gear")
                })
                .accessibility(identifier: "SettingsButton")
                Button(action: {
//                    viewModel.activeActionSheet = .add
                }, label: {
                    Image(systemName: "plus")
                })
//                .actionSheet(item: $viewModel.activeActionSheet) { item in
//                    switch item {
//                    case .add:
//                        return ActionSheet(title: Text("New Account"), buttons: [
//                            .default(Text("Scan QR Code")) { viewModel.navigate(to: .codeScanner) },
//                            .default(Text("Enter Information")) { viewModel.navigate(to: .newAccount) },
//                            .cancel()
//                        ])
//                    }
//                }
            })
            .navigationTitle("Accounts")
//            .sheet(item: $viewModel.activeSheet) { item in
//                switch item {
//                case .codeScanner:
//                    ScanQRCodeView(dismiss: viewModel.hideSheet)
//                case .settings:
//                    SettingsView(dismiss: viewModel.hideSheet)
//                case .newAccount:
//                    NewEditAccountView(dismiss: viewModel.hideSheet, account: viewModel.selectedAccount)
//                }
//            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
