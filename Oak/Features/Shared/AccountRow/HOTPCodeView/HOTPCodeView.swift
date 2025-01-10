//
//  HOTPCodeView.swift
//  Oak
//
//  Created by Alex Catchpole on 07/02/2021.
//

import Foundation
import SwiftUI
import Resolver

struct HOTPCodeView: View {
    @StateObject var viewModel: HOTPCodeViewModel = Resolver.resolve()
    let hasCopied: Bool
    let account: Account
    
    init(hasCopied: Bool, account: Account) {
        self.hasCopied = hasCopied
        self.account = account
    }
    
    var body: some View {
        HStack {
            Text(hasCopied ? "Copied" : viewModel.code)
                .font(Font.system(.subheadline, design: .monospaced).monospacedDigit())
                .transition(.opacity)
                .id(viewModel.code)
                .foregroundColor(.primary)
            Button {
                viewModel.generateCode(increment: true)
            } label: {
                Text("Next").font(.system(.caption)).padding(6)
            }
            .disabled(hasCopied)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
        }
        .onAppear {
            viewModel.setAccount(account: account)
            viewModel.generateCode(increment: false)
        }
    }
}
