//
//  VSC004_StreamCipherTests.swift
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 9/13/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

import Foundation
import XCTest
import VirgilCrypto

class VSC004_StreamCipherTests: XCTestCase {
    var toEncrypt: Data! = nil
    
    override func setUp() {
        super.setUp()
        
        let message = NSString(string: "Secret message which is necessary to be encrypted.")
        self.toEncrypt = message.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
    }
    
    override func tearDown() {
        self.toEncrypt = nil
        
        super.tearDown()
    }
    
    func test001_keyBasedEncryptDecrypt() {
        // Generate a new key pair
        let keyPair = KeyPair()
        // Generate a public key id
        let recipientId = UUID().uuidString
        // Encrypt:
        // Create a cipher instance
        let cipher = StreamCipher()
        // Add a key recepient to enable key-based encryption
        try! cipher.addKeyRecipient(recipientId.data(using: .utf8)!, publicKey: keyPair.publicKey())
        
        let eis = InputStream(data: self.toEncrypt)
        let eos = OutputStream(toMemory: ())
        try! cipher.encryptData(from: eis, to: eos, embedContentInfo: true)
        
        let encryptedData = eos.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        XCTAssertTrue(encryptedData.count > 0, "The data encrypted with key-based encryption should have an actual content.")
        
        // Decrypt:
        // Create a completely new instance of the VCCipher object
        let decipher = StreamCipher()
        
        let dis = InputStream(data: encryptedData)
        let dos = OutputStream(toMemory: ())
        try! decipher.decrypt(from: dis, to: dos, recipientId: recipientId.data(using: .utf8)!, privateKey: keyPair.privateKey(), keyPassword: nil)
        
        let plainData = dos.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        XCTAssertTrue(plainData.count > 0, "Decrypted data should contain actual data.")
        XCTAssertEqual(plainData, self.toEncrypt, "Initial data and decrypted data should be equal.")
    }
    
    func test002_passwordBasedEncryptDecrypt() {
        // Encrypt:
        let password = "secret"
        // Create a cipher instance
        let cipher = StreamCipher()
        // Add a password recepient to enable password-based encryption
        try! cipher.addPasswordRecipient(password)
        
        let eis = InputStream(data: self.toEncrypt)
        let eos = OutputStream(toMemory: ())
        try! cipher.encryptData(from: eis, to: eos, embedContentInfo: false)
        
        let encryptedData = eos.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        XCTAssertTrue(encryptedData.count > 0, "The data encrypted with password-based encryption should have an actual content.");
        
        var contentInfo = try! cipher.contentInfo()
        
        XCTAssertTrue(contentInfo.count > 0, "Content Info should contain necessary information.");
        // Decrypt:
        // Create a completely new instance of the VCCipher object
        let decipher = StreamCipher()
        try! decipher.setContentInfo(contentInfo)

        let dis = InputStream(data: encryptedData)
        let dos = OutputStream(toMemory: ())
        try! decipher.decrypt(from: dis, to: dos, password: password)
        
        let plainData = dos.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        XCTAssertTrue(plainData.count > 0, "The data decrypted with password-based decryption should have an actual content.");
        XCTAssertEqual(plainData, self.toEncrypt, "Initial data and decrypted data should be equal.")
    }
}
