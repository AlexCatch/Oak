//
//  File.swift
//  
//
//  Created by Alex Catchpole on 11/09/2021.
//

import Foundation
import SwiftOTP

public enum OTPServiceError: Error {
    case invalidURI
    case invalidSecret
    case invalidType
}

public enum CodeType: String {
    case hotp = "hotp"
    case totp = "totp"
}

public enum Algorithm: String {
    case sha1 = "SHA1"
    case sha256 = "SHA256"
    case sha512 = "SHA512"
    
    public var swiftOTPAlgorithm: OTPAlgorithm {
        switch self {
        case .sha1:
            return .sha1
        case .sha256:
            return .sha256
        case .sha512:
            return .sha512
        }
    }
}
