//
//  AccountFeature.swift
//  OakOTP
//
//  Created by Alex on 11/01/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AccountsFeature {
    @ObservableState
    struct State {
        var accounts: IdentifiedArrayOf<AccountRowFeature.State> = []
        var error: EquatableError?
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case fetchAccounts
        case fetchedAccounts(IdentifiedArrayOf<AccountRowFeature.State>)
        case accounts(IdentifiedActionOf<AccountRowFeature>)
        case error(EquatableError)
        
        case destination(PresentationAction<Destination.Action>)
        
        enum AddAccountConfirmationDialog: Equatable {
            case scanQRcode
            case enterInformation
        }
        
        enum DeleteAccountConfirmationAlert: Equatable {
            case confirm
        }
        
        case addButtonTapped
    }
    
    @Reducer
    enum Destination {
        case accountForm(AccountFormFeature)
        case addAccountConfirmationDialog(ConfirmationDialogState<AccountsFeature.Action.AddAccountConfirmationDialog>)
        case deleteAccountConfirmationAlert(AlertState<AccountsFeature.Action.DeleteAccountConfirmationAlert>)
    }
    
    @Dependency(\.accountService) var accountService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchAccounts:
                state.error = nil
                return .run { send in
                    do {
                        let results = try await accountService.fetchAll().map { AccountRowFeature.State(account: $0) }
                        await send(.fetchedAccounts(IdentifiedArray(uniqueElements: results)))
                    } catch let error {
                        await send(.error(EquatableError(error)))
                    }
                }
            case .fetchedAccounts(let result):
                state.accounts = result
                return .none
            case .error(let error):
                state.error = error
                return .none
            case .addButtonTapped:
                state.destination = .addAccountConfirmationDialog(
                    ConfirmationDialogState {
                        TextState("New Account")
                    } actions: {
                        ButtonState(action: .scanQRcode) {
                            TextState("Scan QR code")
                        }
                        ButtonState(action: .enterInformation) {
                            TextState("Enter information")
                        }
                    })
                return .none
            case .destination(.presented(.addAccountConfirmationDialog(.enterInformation))):
                state.destination = .accountForm(AccountFormFeature.State())
                return .none
            case .destination(.presented(.addAccountConfirmationDialog(.scanQRcode))):
                return .none
            case .destination(.presented(.accountForm(.delegate(.accountUpserted)))):
                return .run { send in await send(.fetchAccounts) }
            case .accounts:
                return .none
            case .destination:
                return .none
            }
        }
        .forEach(\.accounts, action: \.accounts) {
            AccountRowFeature()
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension AccountsFeature.Destination.State: Equatable {}

struct AccountsView: View {
    @Bindable var store: StoreOf<AccountsFeature>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(store.scope(state: \.accounts, action: \.accounts)) { store in
                        AccountRow(store: store)
                    }
                }
            }
            .navigationBarItems(leading: EditButton(), trailing: HStack {
                Button(action: {
                    //viewModel.navigate(to: .settings)
                }, label: {
                    Image(systemName: "gear")
                })
                Button(action: {
                    store.send(.addButtonTapped)
                }, label: {
                    Image(systemName: "plus")
                })
            })
            .navigationTitle("Accounts")
            .confirmationDialog($store.scope(state: \.destination?.addAccountConfirmationDialog, action: \.destination.addAccountConfirmationDialog))
            .sheet(
                item: $store.scope(state: \.destination?.accountForm, action: \.destination.accountForm)
            ) { store in
                AccountFormView(store: store)
            }
            .onAppear {
                print("did appear")
                store.send(.fetchAccounts)
            }
        }
    }
}
