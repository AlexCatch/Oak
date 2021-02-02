//
//  OTPService.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation

protocol OTPService {
    func parseSetupURI(uri: String) throws -> ParsedURI
}

enum OTPServiceError: Error {
    case invalidURI
}

enum CodeType: String {
    case hotp = "hotp"
    case totp = "totp"
}

enum Algorithm: String {
    case sha1 = "SHA1"
    case sha256 = "SHA265"
    case sha512 = "SHA512"
}

struct ParsedURI {
    let issuer: String
    let username: String?
    let secret: String
    let algorithm: Algorithm
    let type: CodeType
    let digits: String
    
    // Specific to type
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
            let algorithm = queryComponents["algorithm"],
            let algorithmEnum = Algorithm(rawValue: algorithm),
            let type = url.host,
            let typeEnum = CodeType(rawValue: type),
            let digits = queryComponents["digits"]
        else {
            throw OTPServiceError.invalidURI
        }
        
        return ParsedURI(issuer: issuer, username: url.pathComponents.last, secret: secret, algorithm: algorithmEnum, type: typeEnum, digits: digits, period: queryComponents["period"], counter: queryComponents["counter"])
    }
}
