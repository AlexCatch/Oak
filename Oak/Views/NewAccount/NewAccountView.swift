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
            Picker(selection: $selectedAlgorithm, label: Text(selectedAlgorithm.rawValue).foregroundColor(.white).frame(maxWidth: .infinity, alignment: .trailing)) {
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
            Picker(selection: $digits, label: Text(digits.description).foregroundColor(.white).frame(maxWidth: .infinity, alignment: .trailing)) {
                Text("6").tag(6)
                Text("7").tag(7)
                Text("8").tag(8)
                Text("9").tag(9)
                Text("10").tag(10)
            }.pickerStyle(MenuPickerStyle())
        }
    }
}

fileprivate struct PeriodInputRow: View {
    @Binding var period: Int
    
    var body: some View {
        HStack {
            Stepper(value: $period, in: 30...300, label: {
                HStack {
                    Text("Period")
                    Spacer()
                    Text(period == 30 ? "Default" : period.description)
                }
            })
        }
    }
}

struct NewAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: NewAccountViewModel = Resolver.resolve()
    
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
                    SwitchInputRow(title: "Base32 Encoded", isOn: $viewModel.base32Encoded)
                    CodeSelectInputRow(title: "Time-based OTP (TOTP)", type: .totp, selectedType: $viewModel.type)
                    CodeSelectInputRow(title: "Counter-based OTP (HOTP)", type: .hotp, selectedType: $viewModel.type)
                }
                Section(header: Text("Advanced")) {
                    AlgorithmSelectInputRow(selectedAlgorithm: $viewModel.algorithm)
                    DigitsAlgorithmSelectInputRow(digits: $viewModel.digits)
                    
                    if viewModel.type == .totp {
                        PeriodInputRow(period: $viewModel.period).animation(.easeIn)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("New Account")
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Dismiss")
            }), trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Confirm")
            }))
        }
    }
}
