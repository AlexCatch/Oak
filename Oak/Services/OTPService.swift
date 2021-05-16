//
//  OTPService.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import Resolver
import SwiftOTP

protocol OTPService {
    func parseSetupURI(uri: String) throws -> ParsedURI
    func generateCode(account: Account) throws -> String
}

enum OTPServiceError: Error {
    case invalidURI
    case invalidSecret
    case invalidType
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

class RealOTPService: OTPService {
    
    func parseSetupURI(uri: String) throws -> ParsedURI {
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
        
        var parsedURI = ParsedURI(issuer: issuer, username: parseUsername(url: url), secret: secret, algorithm: algorithmEnum, type: typeEnum, period: queryComponents["period"], counter: queryComponents["counter"])
        
        // If we're overriding digits
        if let digits = queryComponents["digits"] {
            parsedURI.digits = digits
        }
        
        return parsedURI
    }
    
    func generateCode(account: Account) throws -> String {
        return account.type == .totp ?
            try generateTOTP(account: account) :
            try generateHOTP(account: account)
    }
    
    private func generateHOTP(account: Account) throws -> String {
        guard let secret = account.decodeSecret() else {
            throw OTPServiceError.invalidSecret
        }

        guard let hotp = HOTP(secret: secret, digits: Int(account.digits), algorithm: account.algorithm.swiftOTPAlgorithm) else {
            throw OTPServiceError.invalidSecret
        }
        let code = hotp.generate(counter: UInt64(account.counter)) ?? ""
        print("code \(code) generated for counter \(account.counter)")
        return code
    }
    
    private func generateTOTP(account: Account, date: Date = Date()) throws -> String {
        guard let secret = account.decodeSecret() else {
            throw OTPServiceError.invalidSecret
        }

        guard let totp = TOTP(secret: secret, digits: Int(account.digits), timeInterval: Int(account.period), algorithm: account.algorithm.swiftOTPAlgorithm) else {
            throw OTPServiceError.invalidSecret
        }

        return totp.generate(time: date) ?? ""
    }
    
    private func parseUsername(url: URL) -> String? {
        return url.pathComponents.last?.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Resolver {
    public static func RegisterOTPService() {
        register { RealOTPService() as OTPService }
    }
}
