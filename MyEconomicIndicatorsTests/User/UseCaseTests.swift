//
//  DummyUser.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import XCTest
@testable import MyEconomicIndicators

// Modelo de prueba
struct DummyUser: Codable, Equatable {
    let email: String
    let password: String
}


final class UseCaseTests: XCTestCase {
    
    func testRegisterAndLoginUser() throws {
        let cache = DiskCache<DummyUser>(folderName: "TestUsers")
        cache.clearAll()
        
        let user = DummyUser(email: "test@mail.com", password: "1234")
        cache.save(user, for: user.email)
        
        // Simular login: cargar usuario desde cache
        let loaded = cache.load(for: user.email)
        XCTAssertEqual(loaded, user, "El usuario cargado debería ser el mismo")
    }
    
    func testLoginFailsForNonExistingUser() {
        let cache = DiskCache<DummyUser>(folderName: "TestUsers")
        cache.clearAll()
        
        let loaded = cache.load(for: "ghost@mail.com")
        XCTAssertNil(loaded, "Un usuario inexistente debería devolver nil")
    }
    
    func testFetchIndicatorsAndCache() async throws {
        
        let fakeDaily = ExchangeResponse(
            success: true,
            source: "CLP",
            quotes: ["CLPUSD": 900.0, "CLPEUR": 1000.0]
        )
        let api = MockAPIClient(responseDaily: fakeDaily)
        let useCase = FetchIndicatorsUseCase(api: api)

        let indicators = try await useCase.fetchDailyIndicators()
        XCTAssertFalse(indicators.isEmpty, "Debería traer indicadores")
        
        // Repetir llamada: debería usar el cache en memoria o disco
        let cached = try await useCase.fetchDailyIndicators()
        XCTAssertEqual(cached.count, indicators.count, "El cache debería devolver mismos indicadores")
    }
    
    func testClearCacheRemovesData() throws {
        let cache = DiskCache<DummyUser>(folderName: "TestUsers")
        let user = DummyUser(email: "clear@test.com", password: "abcd")
        cache.save(user, for: user.email)
        
        XCTAssertNotNil(cache.load(for: user.email))
        
        cache.clearAll()
        XCTAssertNil(cache.load(for: user.email), "El usuario debería haberse borrado al limpiar cache")
    }
}
