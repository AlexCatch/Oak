//
//  ScanQRCodeView.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import CodeScanner
import Resolver

struct ScanQRCodeView: View {
    @StateObject private var viewModel: ScanQRCodeViewModel = Resolver.resolve()
    
    let dismiss: () -> Void
    
    var body: some View {
        NavigationView {
            CodeScannerView(
                codeTypes: [.qr],
                scanMode: .continuous,
                completion: { viewModel.onScan(results: $0, dismiss: dismiss) }
            )
            .navigationBarItems(leading: Button("Dismiss") { dismiss() })
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: viewModel.isPresentingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.scanError ?? ""),
                    dismissButton: .default(Text("Okay"))
                )
            }
        }
    }
}
