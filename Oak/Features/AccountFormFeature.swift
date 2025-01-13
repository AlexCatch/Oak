//
//  AccountFormFeature.swift
//  OakOTP
//
//  Created by Alex on 12/01/2025.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@Reducer
struct AccountFormFeature {
    @ObservableState
    struct State: Equatable {
        var account: Account?
        
        var name = ""
        var issuer = ""
        var secret = ""
        var base32Encoded = true
        var type: CodeType = .totp
        var algorithm: Algorithm = .sha1
        var digits: Int = 6
        var period: Int = 30
        var counter: Int = 0
        
        var navigationTitle: String {
          return account != nil ? "Edit Account" : "New Account"
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dismissButtonTapped
        case confirmButtonTapped
        case delegate(Delegate)
        
        enum Delegate {
            case accountUpserted(Account)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.accountService) var accountService
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .dismissButtonTapped:
                return .run { _ in await dismiss()}
            case .confirmButtonTapped:
                return .run { [
                    name = state.name,
                    issuer = state.issuer,
                    secret = state.secret,
                    base32Encoded = state.base32Encoded,
                    type = state.type,
                    algorithm = state.algorithm,
                    digits = state.digits,
                    period = state.period,
                    counter = state.counter
                ] send in
                    let accountData = CreateAccountData(name: name, issuer: issuer, secret: secret, base32Encoded: base32Encoded, type: type, algorithm: algorithm, digits: digits, period: period, counter: counter)
                    let account = try await accountService.create(accountData)
                    await send(.delegate(.accountUpserted(account)))
                    await dismiss()
                }
            case .delegate:
                return .none
            case .binding:
                return .none
            }
        }
    }
}

fileprivate struct TextInputRow: View {
    let title: String
    let placeholder: String
    
    @Binding var input: String
    
    var body: some View {
        HStack {
            Text(title)
            TextField(placeholder, text: $input)
                .multilineTextAlignment(.trailing)
        }
    }
}

fileprivate struct CodeSelectInputRow: View {
    let title: String
    let type: CodeType
    
    @Binding var selectedType: CodeType
    
    var body: some View {
        Button {
            selectedType = type
        } label: {
            HStack {
                Text(title).foregroundColor(.primary)
                Spacer()
                if type == selectedType {
                    Image(systemName: "checkmark.circle")
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                }
            }
            .contentShape(Rectangle())
        }
    }
}

fileprivate struct StepperInputRow: View {
    @Binding var value: Int
    
    let title: String
    let min: Int
    let max: Int
    
    var body: some View {
        HStack {
            Stepper(value: $value, in: min...max, label: {
                HStack {
                    Text(title)
                    Spacer()
                    Text(value == min ? min.description : value.description)
                }
            })
        }
    }
}

struct AccountFormView: View {
    @Bindable var store: StoreOf<AccountFormFeature>
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    TextInputRow(title: "Name", placeholder: "john@doe.com", input: $store.name)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextInputRow(title: "Issuer", placeholder: "Github", input: $store.issuer)
                }
                Section() {
                    TextInputRow(title: "Secret", placeholder: "Secret", input: $store.secret)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Toggle("Base32 Encoded", isOn: $store.base32Encoded)
                    CodeSelectInputRow(title: "Time-based OTP (TOTP)", type: .totp, selectedType: $store.type)
                    CodeSelectInputRow(title: "Counter-based OTP (HOTP)", type: .hotp, selectedType: $store.type)
                }
                Section(header: Text("Advanced")) {
                    Picker("Algorithm", selection: $store.algorithm) {
                        Text("SHA1").tag(Algorithm.sha1)
                        Text("SHA256").tag(Algorithm.sha256)
                        Text("SHA512").tag(Algorithm.sha512)
                    }.pickerStyle(MenuPickerStyle())
                    Picker("Digits", selection: $store.digits) {
                        Text("6").tag(6)
                        Text("7").tag(7)
                        Text("8").tag(8)
                    }.pickerStyle(MenuPickerStyle())
                    if store.type == .totp {
                        StepperInputRow(value: $store.period, title: "Period", min: 30, max: 300)
                    } else {
                        StepperInputRow(value: $store.counter, title: "Counter", min: 0, max: Int(Int16.max))
                    }
                }
//                if viewModel.account != nil {
//                    Section() {
//                        Button(action: {
//                            viewModel.requestDelete()
//                        }, label: {
//                            Text("Delete")
//                                .bold()
//                                .foregroundColor(.red)
//                        })
//                    }
//                }
            }
            .navigationTitle(store.navigationTitle)
//            .alert(isPresented: $viewModel.deletionRequested) {
//                Alert(
//                    title: Text("Delete"),
//                    message: Text("Are you sure you want to delete this account? This cannot be undone so please make sure you've backed up your secret elsewhere"),
//                    primaryButton: .destructive(Text("Delete"), action: viewModel.confirmDeletion),
//                    secondaryButton: .cancel()
//                )
//            }
            .navigationBarItems(leading: Button(action: {
                store.send(.dismissButtonTapped)
            }, label: {
                Text("Dismiss")
            }), trailing: Button(action: {
                store.send(.confirmButtonTapped)
            }, label: {
                Text("Confirm")
            }))
//            .onAppear {
//                viewModel.dismiss = dismiss
//                viewModel.setAccount(account: account)
//            }
        }
    }
}
