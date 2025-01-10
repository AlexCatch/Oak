//
//  OTPService.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import Resolver
import SwiftOTP
import Dependencies
import DependenciesMacros

enum OTPServiceError: Error {
    case invalidURI
    case invalidUsername
    case invalidSecret
    case invalidType
    case failedCodeGeneration
}

enum CodeType: String {
    case hotp = "hotp"
    case totp = "totp"
}

enum Algorithm: String {
    case sha1 = "SHA1"
    case sha256 = "SHA265"
    case sha512 = "SHA512"
    
    var swiftOTPAlgorithm: OTPAlgorithm {
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

struct ParsedURI {
    let issuer: String
    let username: String?
    let secret: String
    let algorithm: Algorithm
    let type: CodeType
    
    var digits: String = "6"
    var period: String?
    var counter: String?
}

struct OTPService {
    var parseSetupURI: (_ uri: String) throws -> ParsedURI
    var generateCode: (_ account: Account) throws -> String
}

extension OTPService: DependencyKey {
    static var liveValue: Self {
        func generateHOTP(account: Account) throws -> String {
            guard let secret = account.decodeSecret() else {
                throw OTPServiceError.invalidSecret
            }

            guard let hotp = HOTP(secret: secret, digits: Int(account.digits), algorithm: account.algorithm.swiftOTPAlgorithm) else {
                throw OTPServiceError.invalidSecret
            }
            guard let code = hotp.generate(counter: UInt64(account.counter)) else {
                throw OTPServiceError.failedCodeGeneration
            }
            return code
        }
        
        func generateTOTP(account: Account, date: Date = Date()) throws -> String {
            guard let secret = account.decodeSecret() else {
                throw OTPServiceError.invalidSecret
            }

            guard let totp = TOTP(secret: secret, digits: Int(account.digits), timeInterval: Int(account.period), algorithm: account.algorithm.swiftOTPAlgorithm) else {
                throw OTPServiceError.invalidSecret
            }

            guard let code = totp.generate(time: date) else {
                throw OTPServiceError.failedCodeGeneration
            }
            return code
        }
        
        func parseUsername(url: URL) throws -> String {
            guard let parsedUsername = url.pathComponents.last?.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                throw OTPServiceError.invalidUsername
            }
            return parsedUsername
        }
        
        return Self { uri in
            guard let url = URL(string: uri), let queryComponents = url.queryDictionary else {
                throw OTPServiceError.invalidURI
            }
            
            guard
                let issuer = queryComponents["issuer"],
                let secret = queryComponents["secret"],
                let algorithmEnum = Algorithm(rawValue: queryComponents["algorithm"] ?? "SHA1"),
                let type = url.host,
                let typeEnum = CodeType(rawValue: type)
            else {
                throw OTPServiceError.invalidURI
            }
            
            var parsedURI = ParsedURI(issuer: issuer, username: try parseUsername(url: url), secret: secret, algorithm: algorithmEnum, type: typeEnum, period: queryComponents["period"], counter: queryComponents["counter"])
            
            // If we're overriding digits
            if let digits = queryComponents["digits"] {
                parsedURI.digits = digits
            }
            
            return parsedURI
        } generateCode: { account in
            return account.type == .totp ?
                try generateTOTP(account: account) :
                try generateHOTP(account: account)
        }
    }
    static var testValue: Self {
        return .liveValue
    }
    static var previewValue: Self {
        return .liveValue
    }
}

extension DependencyValues {
    var otpService: OTPService {
        get { self[OTPService.self] }
        set { self[OTPService.self] = newValue }
  }
}
