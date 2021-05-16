//
//  NewAccountView.swift
//  Oak
//
//  Created by Alex Catchpole on 04/02/2021.
//

import Foundation
import SwiftUI
import Resolver

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

fileprivate struct SwitchInputRow: View {
    let title: String
    
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Toggle(title, isOn: $isOn)
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

fileprivate struct AlgorithmSelectInputRow: View {
    @Binding var selectedAlgorithm: Algorithm
    
    var body: some View {
        HStack {
            Text("Algorithm")
            Spacer()
            Picker(selection: $selectedAlgorithm, label: Text(selectedAlgorithm.rawValue).foregroundColor(.primary).frame(maxWidth: .infinity, alignment: .trailing)) {
                Text("SHA1").tag(Algorithm.sha1)
                Text("SHA256").tag(Algorithm.sha256)
                Text("SHA512").tag(Algorithm.sha512)
            }.pickerStyle(MenuPickerStyle())
        }
    }
}

fileprivate struct DigitsAlgorithmSelectInputRow: View {
    @Binding var digits: Int
    
    var body: some View {
        HStack {
            Text("Digits")
            Spacer()
            Picker(selection: $digits, label: Text(digits.description).foregroundColor(.primary).frame(maxWidth: .infinity, alignment: .trailing)) {
                Text("6").tag(6)
                Text("7").tag(7)
                Text("8").tag(8)
            }.pickerStyle(MenuPickerStyle())
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
                    Text(value == min ? "Default" : value.description)
                }
            })
        }
    }
}

struct NewEditAccountView: View {
    @StateObject private var viewModel: NewEditAccountViewModel = Resolver.resolve()
    
    let dismiss: () -> Void
    let account: Account?
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    TextInputRow(title: "Name", placeholder: "john@doe.com", input: $viewModel.name)
                        .textContentType(.emailAddress)
                    TextInputRow(title: "Issuer", placeholder: "Github", input: $viewModel.issuer)
                }
                Section() {
                    TextInputRow(title: "Secret", placeholder: "Secret", input: $viewModel.secret)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SwitchInputRow(title: "Base32 Encoded", isOn: $viewModel.base32Encoded)
                    CodeSelectInputRow(title: "Time-based OTP (TOTP)", type: .totp, selectedType: $viewModel.type)
                    CodeSelectInputRow(title: "Counter-based OTP (HOTP)", type: .hotp, selectedType: $viewModel.type)
                }
                Section(header: Text("Advanced")) {
                    AlgorithmSelectInputRow(selectedAlgorithm: $viewModel.algorithm)
                    DigitsAlgorithmSelectInputRow(digits: $viewModel.digits)
                    
                    if viewModel.type == .totp {
                        StepperInputRow(value: $viewModel.period, title: "Period", min: 30, max: 300)
                    } else {
                        StepperInputRow(value: $viewModel.counter, title: "Counter", min: 0, max: Int(Int16.max))
                    }
                }
                if viewModel.account != nil {
                    Section() {
                        Button(action: {
                            viewModel.requestDelete()
                        }, label: {
                            Text("Delete")
                                .bold()
                                .foregroundColor(.red)
                        })
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .alert(isPresented: $viewModel.deletionRequested) {
                Alert(
                    title: Text("Delete"),
                    message: Text("Are you sure you want to delete this account? This cannot be undone so please make sure you've backed up your secret elsewhere"),
                    primaryButton: .destructive(Text("Delete"), action: viewModel.confirmDeletion),
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarItems(leading: Button(action: {
                viewModel.dismiss?()
            }, label: {
                Text("Dismiss")
            }), trailing: Button(action: {
                viewModel.save()
            }, label: {
                Text("Confirm")
            }).disabled(!viewModel.inputsValid))
            .onAppear {
                viewModel.dismiss = dismiss
                viewModel.setAccount(account: account)
            }
        }
    }
}
