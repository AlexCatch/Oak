//
//  ScanQRCodeViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import Foundation
import SwiftUI
import Resolver
import CodeScanner

class ScanQRCodeViewModel: ObservableObject {
    @Injected private var otpService: OTPService
    @Injected private var accountsService: AccountService
    
    @Published var scanError: String?
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(get: {
            return self.scanError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.scanError = nil
        })
    }
    
    func onScan(results: Result<String, CodeScannerView.ScanError>, dismiss: () -> Void) {
        do {
            let uri = try results.get()
            let parsedUri = try otpService.parseSetupURI(uri: uri)
            try accountsService.save(parsedURI: parsedUri)
            dismiss()
        } catch {
            scanError = "Failed to parse QR code - double check you're scanning a valid code"
        }
    }
}

extension Resolver {
    static func RegisterScanQRCodeViewModel() {
        register { ScanQRCodeViewModel() }
    }
}
