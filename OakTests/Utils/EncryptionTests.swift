//
//  EncryptionTests.swift
//  OakOTPTests
//
//  Created by Alex Catchpole on 03/08/2021.
//

import XCTest
@testable import OakOTP

class EncryptionTests: XCTestCase {
    func testDecryptionWithValidKey() throws {
        let dataToEncrypt = "helloworld"
        let key = "TDHSr3PnZ2fFEUCT"
        
        let encryption = RealEncryption()
        let encryptedString = try encryption.encrypt(data: dataToEncrypt, key: key)
        
        // Assert we've at least done something to our secret data
        XCTAssertNotEqual(encryptedString, dataToEncrypt)
        XCTAssertNotNil(encryptedString)
        
        // attempt to decrypt
        let decryptedString = try encryption.decrypt(encryptedString: encryptedString, key: key)

        // assert correct decryption
        XCTAssertEqual(dataToEncrypt, decryptedString)
        XCTAssertNotNil(decryptedString)
    }
    
    func testDecryptionFailsWithInvalidKey() throws {
        let dataToEncrypt = "helloworld"
        let key = "TDHSr3PnZ2fFEUCT"
        let invalidKey = "FFFSr3PnZ2fFEUCF"
        
        let encryption = RealEncryption()
        let encryptedString = try encryption.encrypt(data: dataToEncrypt, key: key)
        
        // attempt to decrypt
        let decryptedString = try encryption.decrypt(encryptedString: encryptedString, key: invalidKey)

        // assert correct decryption
        XCTAssertNotEqual(dataToEncrypt, decryptedString)
        XCTAssertNotNil(decryptedString)
    }
    
    func testKeyPadding() throws {
        let dataToEncrypt = "helloworld"
        let key = "smallkey"
        
        let encryption = RealEncryption()
        let encryptedString = try encryption.encrypt(data: dataToEncrypt, key: key)
        
        // attempt to decrypt
        let decryptedString = try encryption.decrypt(encryptedString: encryptedString, key: key)

        // assert correct decryption
        XCTAssertEqual(dataToEncrypt, decryptedString)
        XCTAssertNotNil(decryptedString)
    }
}
