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
    @Environment(\.presentationMode) var presentationMode
    
    var onScan: (_ parsedURI: ParsedURI) -> Void
    
    var body: some View {
        NavigationView {
            CodeScannerView(
                codeTypes: [.qr],
                scanMode: .continuous,
                completion: viewModel.onScan
            )
            .navigationBarItems(leading: Button("Dismiss") { presentationMode.wrappedValue.dismiss() })
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: viewModel.isPresentingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.scanError ?? ""),
                    dismissButton: .default(Text("Okay"))
                )
            }
            .onAppear {
                viewModel.onURIParsed = onScan
            }
        }
    }
}
