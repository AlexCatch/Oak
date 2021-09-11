//
//  TOTPCodeView.swift
//  Oak
//
//  Created by Alex Catchpole on 06/02/2021.
//

import Foundation
import SwiftUI
import Resolver
import OakOTPCommon

struct TOTPCodeView: View {
    @StateObject private var viewModel: TOTPCodeViewModel = Resolver.resolve()
    private let hasCopied: Bool
    private let account: Account
    
    init(hasCopied: Bool, account: Account) {
        self.hasCopied = hasCopied
        self.account = account
    }
    
    var body: some View {
        HStack {
            Text(hasCopied ? "Copied" : viewModel.code)
                .font(Font.system(.subheadline, design: .monospaced).monospacedDigit())
                .transition(.opacity)
                .id(UUID().uuidString)
                .foregroundColor(.primary)
            CircularProgressView(lineWidth: 1, progress: viewModel.progress, remain: viewModel.timeRemaining)
                .frame(width: 25, height: 25, alignment: .leading).id(UUID().uuidString)
        }
        .onAppear {
            viewModel.account = account
            viewModel.generateCode()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}
