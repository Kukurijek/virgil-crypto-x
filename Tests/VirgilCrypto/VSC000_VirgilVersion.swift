//
//  VSC000_VirgilVersion.swift
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 2/2/18.
//  Copyright © 2018 VirgilSecurity. All rights reserved.
//

import Foundation
import VirgilCrypto
import XCTest

class VSC000_VirgilVersion: XCTestCase {
    func test001() {
        XCTAssert(VirgilVersion.asNumber() == 2 << 16 | 2 << 8 | 5)
        XCTAssert(VirgilVersion.asString() == "2.2.5")
        XCTAssert(VirgilVersion.majorVersion() == 2)
        XCTAssert(VirgilVersion.minorVersion() == 2)
        XCTAssert(VirgilVersion.patchVersion() == 5)
        XCTAssert(VirgilVersion.fullName() == "2.2.5")
    }
}
