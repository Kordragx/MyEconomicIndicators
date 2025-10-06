//
//  PasswordHasher.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import CryptoKit
import Foundation

struct PasswordHasher {
    static func hash(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
