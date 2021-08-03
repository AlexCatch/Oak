//
//  Encryption.swift
//  OakOTP
//
//  Created by Alex Catchpole on 03/08/2021.
//

import Foundation
import CryptoSwift
import Resolver

protocol Encryption {
    func encrypt(data: String, key: String) throws -> String
    func decrypt(encryptedString: String, key: String) throws -> String
}

class RealEncryption: Encryption {
    
    func encrypt(data: String, key: String) throws -> String {
        var keyBytes = key.bytes
        let dataBytes = data.bytes
        
        // Pad our key to the correct size
        keyBytes = Padding.pkcs7.add(to: keyBytes, blockSize: AES.blockSize)
        
        let iv = AES.randomIV(AES.blockSize)
        let aes = try AES(key: keyBytes, blockMode: CBC(iv: iv), padding: .pkcs7)
        
        let encryptedBytes = try aes.encrypt(dataBytes)

        return String(data: Data(iv + encryptedBytes).base64EncodedData(), encoding: .utf8) ?? ""
    }
    
    func decrypt(encryptedString: String, key: String) throws -> String {
        var keyBytes = key.bytes
        guard var encryptedData = Data(base64Encoded: encryptedString) else {
            return ""
        }
        
        // Pad our key to the correct size
        keyBytes = Padding.pkcs7.add(to: keyBytes, blockSize: AES.blockSize)
        
        guard let iv = stripIV(from: &encryptedData) else {
            return ""
        }
        
        let aes = try AES(key: keyBytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7)
        
        let decryptedBytes = try aes.decrypt(encryptedData.bytes)
        return String(data: Data(decryptedBytes), encoding: .utf8) ?? ""
    }
    
    private func stripIV(from data: inout Data) -> Data? {
        let ivBytes = data.extract(from: &data, length: AES.blockSize)
        return ivBytes
    }
}

extension Resolver {
    static func RegisterEncryptionUtil() {
        register { RealEncryption() as Encryption }.scope(.shared)
    }
}
