//
//  PasswordHasherTests.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


import XCTest
@testable import MyEconomicIndicators

final class PasswordHasherTests: XCTestCase {
    func testHashConsistency() {
        let password = "123456"
        let hash1 = PasswordHasher.hash(password)
        let hash2 = PasswordHasher.hash(password)
        
        XCTAssertEqual(hash1, hash2, "Hash should be consistent for same input")
    }
}
