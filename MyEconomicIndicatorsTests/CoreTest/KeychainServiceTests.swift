//
//  KeychainServiceTests.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


//
//  KeychainServiceTests.swift
//  MyEconomicIndicatorsTests
//
//  Created by Daniel Nunez on 06-10-25.
//

import XCTest
@testable import MyEconomicIndicators

@MainActor
final class KeychainServiceTests: XCTestCase {
    
    let sut = KeychainService.shared
    let testKey = "unitTestKey"

    override func tearDown() {
        // 🔹 Limpiar el keychain después de cada test
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: testKey
        ]
        SecItemDelete(query as CFDictionary)
        super.tearDown()
    }

    func test_saveAndRetrieveValue() {
        let value = "MySecretValue"

        sut.save(value: value, for: testKey)
        let retrieved = sut.getValue(for: testKey)

        XCTAssertEqual(retrieved, value)
    }

    func test_overwriteValue_retrievesLatest() {
        let firstValue = "FirstValue"
        let secondValue = "SecondValue"

        sut.save(value: firstValue, for: testKey)
        sut.save(value: secondValue, for: testKey)

        let retrieved = sut.getValue(for: testKey)

        XCTAssertEqual(retrieved, secondValue)
    }

    func test_getValue_nonExistentKey_returnsNil() {
        let retrieved = sut.getValue(for: "nonExistentKey")
        XCTAssertNil(retrieved)
    }
}
