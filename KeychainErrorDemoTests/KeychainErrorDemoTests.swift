//
//  KeychainErrorDemoTests.swift
//  KeychainErrorDemoTests
//
//  Created by Brennan Stehling on 9/18/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest
@testable import KeychainErrorDemo

class KeychainErrorDemoTests: XCTestCase {

    func testDeleteAccessData() {
        let success = Keychain.sharedInstance.deleteAccessData()
        XCTAssertTrue(success)
    }

    func testStoreAccessData() {
        var success = Keychain.sharedInstance.deleteAccessData()
        XCTAssertTrue(success)

        let accessToken = "abcxyz"
        Keychain.sharedInstance.accessToken = accessToken
        XCTAssertNotNil(Keychain.sharedInstance.accessToken)

        success = Keychain.sharedInstance.storeAccessData()

        XCTAssertTrue(success)
    }

    func testLoadAccessData() {
        var success = Keychain.sharedInstance.deleteAccessData()
        XCTAssertTrue(success)

        let accessToken = "abcxyz"
        Keychain.sharedInstance.accessToken = accessToken
        XCTAssertNotNil(Keychain.sharedInstance.accessToken)

        success = Keychain.sharedInstance.storeAccessData()
        XCTAssertTrue(success)

        Keychain.sharedInstance.accessToken = nil

        success = Keychain.sharedInstance.loadAccessData()
        XCTAssertTrue(success)
        XCTAssertTrue(Keychain.sharedInstance.accessToken == accessToken)
    }

}
