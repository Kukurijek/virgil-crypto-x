//
//  VirgilPublicKey.swift
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 9/18/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

import Foundation
import VirgilCryptoAPI

@objc(VSCVirgilPublicKey) public class VirgilPublicKey: NSObject {
    @objc let identifier: Data
    @objc let rawKey: Data
    
    @objc init(identifier: Data, rawKey: Data) {
        self.identifier = identifier
        self.rawKey = rawKey
        
        super.init()
    }
}

extension VirgilPublicKey: PublicKey { }
