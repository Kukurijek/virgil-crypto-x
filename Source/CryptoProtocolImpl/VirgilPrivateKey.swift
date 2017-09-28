//
//  VirgilPrivateKey.swift
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 9/18/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

import Foundation
import VirgilCryptoAPI

@objc(VSCVirgilPrivateKey) public class VirgilPrivateKey: NSObject {
    @objc let identifier: Data
    @objc let key: Data
    
    @objc init(identifier: Data, key: Data) {
        self.identifier = identifier
        self.key = key
        
        super.init()
    }
}

extension VirgilPrivateKey: PrivateKey { }
