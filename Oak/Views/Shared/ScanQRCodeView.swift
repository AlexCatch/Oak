//
//  ScanQRCodeView.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import CodeScanner

struct ScanQRCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var onScan: (Result<String, CodeScannerView.ScanError>) -> Void
    
    var body: some View {
        NavigationView {
            CodeScannerView(
                codeTypes: [.qr],
                scanMode: .once,
                completion: onScan
            )
            .navigationBarItems(leading: Button("Dismiss") { presentationMode.wrappedValue.dismiss() })
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
