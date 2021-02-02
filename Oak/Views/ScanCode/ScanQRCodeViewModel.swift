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
    
    @Published var scanError: String?
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(get: {
            return self.scanError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.scanError = nil
        })
    }
    var onURIParsed: ((_ uri: ParsedURI) -> Void)?
    
    func onScan(results: Result<String, CodeScannerView.ScanError>) {
        guard let callback = onURIParsed else {
            return
        }
        
        do {
            let uri = try results.get()
            callback(try otpService.parseSetupURI(uri: uri))
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
