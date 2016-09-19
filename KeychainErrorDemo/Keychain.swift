//
//  Keychain.swift
//  KeychainErrorDemo
//
//  Created by Brennan Stehling on 9/18/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import Security

internal let DemoKeychainAccount: String = "ErrorDemo"
internal let DemoAccessTokenKey: String = "access_token"

public class Keychain {

    var accessToken: String?

    static let sharedInstance = Keychain()

    internal func storeAccessData() -> Bool {
        guard deleteAccessData() else {
            return false
        }
        var success = false

        if let accessToken = accessToken {

            let dictionary: [String : Any] = [
                DemoAccessTokenKey : accessToken as AnyObject
            ]

            let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictionary)

            let query: [String : Any] = [
                kSecClass as String : kSecClassGenericPassword,
                kSecAttrAccount as String : DemoKeychainAccount as AnyObject,
                kSecValueData as String : data,
                kSecAttrAccessible as String  : kSecAttrAccessibleAlways as String
            ]

            let resultCode = SecItemAdd(query as CFDictionary, nil)

            success = resultCode == noErr
        }

        return success
    }

    internal func loadAccessData() -> Bool {
        var success = false

        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : DemoKeychainAccount as AnyObject,
            kSecReturnData as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]

        var result: AnyObject?

        let resultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        if resultCode == noErr {
            if let data = result as? Data {
                if let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any],
                    let accessToken = dictionary[DemoAccessTokenKey] as? String {
                    self.accessToken = accessToken
                    success = true
                }
            }
        }

        return success
    }

    internal func deleteAccessData() -> Bool {
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : DemoKeychainAccount
        ]

        let resultCode = SecItemDelete(query as CFDictionary)

        if resultCode == -34018 {
            // Missing Entitlements?
            // https://github.com/DinosaurDad/Keychain-34018
            // https://forums.developer.apple.com/thread/4743
            debugPrint("Keychain Status: \(resultCode)")
        }
        
        return resultCode == noErr || resultCode == errSecItemNotFound
    }
    
}
