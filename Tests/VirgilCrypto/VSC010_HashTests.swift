//
//  VSC010_HashTests.swift
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 9/13/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

import Foundation
import XCTest
import VirgilCrypto

class VSC010_HashTests: XCTestCase {
    func test001_calculateMD5() {
        let h = Hash(algorithm: .MD5)
        let plainString = "secret"
        let expectedHashString = "5ebe2294ecd0e0f08eab7690d2a6ee69"
        
        let hashData = h.hash(plainString.data(using: .utf8))
        let hexString = ByteArrayUtils.hexString(from: hashData)
        
        XCTAssert(expectedHashString == hexString)
        
        XCTAssert(h.hash(Data()).base64EncodedString() == "1B2M2Y8AsgTpgAmY7PhCfg==")
        XCTAssert(h.hash(nil).base64EncodedString() == "1B2M2Y8AsgTpgAmY7PhCfg==")
    }
    
    func test002_calculateSHA1() {
        let h = Hash(algorithm: .SHA1)
        let plainString = "secret"
        let expectedHashString = "e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4"
        
        let hashData = h.hash(plainString.data(using: .utf8))
        let hexString = ByteArrayUtils.hexString(from: hashData)
        
        XCTAssert(expectedHashString == hexString)
        
        XCTAssert(h.hash(Data()).base64EncodedString() == "2jmj7l5rSw0yVb/vlWAYkK/YBwk=")
        XCTAssert(h.hash(nil).base64EncodedString() == "2jmj7l5rSw0yVb/vlWAYkK/YBwk=")
    }
    
    func test003_calculateSHA224() {
        let h = Hash(algorithm: .SHA224)
        let plainString = "secret"
        let expectedHashString = "95c7fbca92ac5083afda62a564a3d014fc3b72c9140e3cb99ea6bf12"
        
        let hashData = h.hash(plainString.data(using: .utf8))
        let hexString = ByteArrayUtils.hexString(from: hashData)
        
        XCTAssert(expectedHashString == hexString)
        
        XCTAssert(h.hash(Data()).base64EncodedString() == "0UoCjCo6K8lHYQK7KII0xBWisB+CjqYqxbPkLw==")
        XCTAssert(h.hash(nil).base64EncodedString() == "0UoCjCo6K8lHYQK7KII0xBWisB+CjqYqxbPkLw==")
    }
    
    func test004_calculateSHA256() {
        let h = Hash(algorithm: .SHA256)
        let plainString = "secret"
        let expectedHashString = "2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b"
        
        let hashData = h.hash(plainString.data(using: .utf8))
        let hexString = ByteArrayUtils.hexString(from: hashData)
        
        XCTAssert(expectedHashString == hexString)
        
        XCTAssert(h.hash(Data()).base64EncodedString() == "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=")
        XCTAssert(h.hash(nil).base64EncodedString() == "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=")
    }
    
    func test005_calculateSHA384() {
        let h = Hash(algorithm: .SHA384)
        let plainString = "secret"
        let expectedHashString = "58a775ba4112be3005ae4407ce757d88fda71d40497bb8026ecac54d4e3ffc7232ce8de3ab5acb30ae39760fee7c53ed"
        
        let hashData = h.hash(plainString.data(using: .utf8))
        let hexString = ByteArrayUtils.hexString(from: hashData)
        
        XCTAssert(expectedHashString == hexString)
        
        XCTAssert(h.hash(Data()).base64EncodedString() == "OLBgp1GsljhM2TJ+sbHjaiH9txEUvgdDTAzHv2P24donTt6/529l+9Ua0vFImLlb")
        XCTAssert(h.hash(nil).base64EncodedString() == "OLBgp1GsljhM2TJ+sbHjaiH9txEUvgdDTAzHv2P24donTt6/529l+9Ua0vFImLlb")
    }
    
    func test006_calculateSHA512() {
        let h = Hash(algorithm: .SHA512)
        let plainString = "secret"
        let expectedHashString = "bd2b1aaf7ef4f09be9f52ce2d8d599674d81aa9d6a4421696dc4d93dd0619d682ce56b4d64a9ef097761ced99e0f67265b5f76085e5b0ee7ca4696b2ad6fe2b2"
        
        let hashData = h.hash(plainString.data(using: .utf8))
        let hexString = ByteArrayUtils.hexString(from: hashData)
        
        XCTAssert(expectedHashString == hexString)
        
        XCTAssert(h.hash(Data()).base64EncodedString() == "z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg/SpIdNs6c5H0NE8XYXysP+DGNKHfuwvY7kxvUdBeoGlODJ6+SfaPg==")
        XCTAssert(h.hash(nil).base64EncodedString() == "z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg/SpIdNs6c5H0NE8XYXysP+DGNKHfuwvY7kxvUdBeoGlODJ6+SfaPg==")
    }
}
