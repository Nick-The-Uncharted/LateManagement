//
//  KeychainHelper.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainHelper {
    static func getPassword(userId: String) -> String? {
        let keychain = Keychain(service: "com.baixing.nick.password")
            .accessibility(.AfterFirstUnlock)
        
        if let password = try? keychain.getString(userId) {
            return password
        } else {
            return nil
        }
    }
    
    static func setPassword(userId: String, password: String) {
        let keychain = Keychain(service: "com.baixing.nick.password")
            .accessibility(.AfterFirstUnlock)
        keychain[userId] = password
    }
}