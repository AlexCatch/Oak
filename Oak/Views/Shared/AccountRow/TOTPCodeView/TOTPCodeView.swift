//
//  TOTPCodeView.swift
//  Oak
//
//  Created by Alex Catchpole on 06/02/2021.
//

import Foundation
import SwiftUI

struct TOTPCodeView: View {
    @ObservedObject private var viewModel: TOTPCodeViewModel
    
    init(viewModel: TOTPCodeViewModel) {
        self.viewModel = viewModel
        
        // Kick off our code generation flow
        viewModel.generateCode()
    }
    
    var body: some View {
        HStack {
            Text(viewModel.code)
            CircularProgressView(lineWidth: 2, progress: viewModel.progress, remain: viewModel.timeRemaining)
                .frame(width: 25, height: 25, alignment: .leading).id(UUID().uuidString)
        }
        .onAppear {
            viewModel.generateCode()
        }
        .onDisappear {
            print("TOTP did dissipear")
            viewModel.stop()
        }
    }
}
