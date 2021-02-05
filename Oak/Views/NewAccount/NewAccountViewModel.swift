//
//  NewAccountViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 05/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class NewAccountViewModel: ObservableObject {
    @Published var name = ""
    @Published var issuer = ""
    @Published var secret = ""
    @Published var base32Encoded = true
    @Published var type: CodeType = .totp
    @Published var algorithm: Algorithm = .sha1
    @Published var digits: Int = 6
    @Published var period: Int = 30
}

extension Resolver {
    static func RegisterNewAccountViewModel() {
        register { NewAccountViewModel() }
    }
}
