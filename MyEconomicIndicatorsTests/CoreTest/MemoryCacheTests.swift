//
//  MemoryCacheTests.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import XCTest
@testable import MyEconomicIndicators

final class MemoryCacheTests: XCTestCase {
    
    func testSetAndGetValue() {
        let cache = MemoryCache<String, Int>(duration: 5)
        cache.set("testKey", value: 42)
        
        let value = cache.get("testKey")
        
        XCTAssertEqual(value, 42, "El valor debería ser el mismo que se insertó")
    }
    
    func testValueExpiresAfterDuration() {
        let cache = MemoryCache<String, String>(duration: 1) // 1 seg
        cache.set("token", value: "12345")
        
        // esperar 2 segundos para asegurar expiración
        sleep(2)
        
        let value = cache.get("token")
        XCTAssertNil(value, "El valor debería haber expirado")
    }
    
    func testOverwriteValue() {
        let cache = MemoryCache<String, Int>(duration: 5)
        cache.set("counter", value: 10)
        cache.set("counter", value: 20)
        
        let value = cache.get("counter")
        XCTAssertEqual(value, 20, "El valor debería haber sido sobrescrito")
    }
    
    func testClearCache() {
        let cache = MemoryCache<String, Int>(duration: 5)
        cache.set("a", value: 1)
        cache.set("b", value: 2)
        
        cache.clear()
        
        XCTAssertNil(cache.get("a"))
        XCTAssertNil(cache.get("b"))
    }
    
    func testGetNonExistingKey() {
        let cache = MemoryCache<String, String>()
        
        XCTAssertNil(cache.get("inexistente"), "Un key inexistente debería devolver nil")
    }
}
