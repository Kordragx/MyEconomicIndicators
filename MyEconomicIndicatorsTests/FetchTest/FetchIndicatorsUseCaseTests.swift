//
//  FetchIndicatorsUseCaseTests.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


import XCTest
@testable import MyEconomicIndicators

@MainActor
final class FetchIndicatorsUseCaseTests: XCTestCase {
    
    func testDailyIndicatorsFromAPI() async throws {
        let fakeDaily = ExchangeResponse(
            success: true,
            source: "CLP",
            quotes: ["CLPUSD": 900.0, "CLPEUR": 1000.0]
        )
        let mockAPI = MockAPIClient(responseDaily: fakeDaily)
        
        let useCase = FetchIndicatorsUseCase(api: mockAPI)
        let indicators = try await useCase.fetchDailyIndicators()
        
        XCTAssertEqual(indicators.count, 2)
        XCTAssertTrue(indicators.contains { $0.pair.rawValue == "CLPUSD" })
    }
    
    func testDailyIndicatorsFromDiskCache() async throws {
        let mockAPI = MockAPIClient()
        let useCase = FetchIndicatorsUseCase(api: mockAPI)
        
        let expected = [Indicator(pair: .clpToUsd, rawValue: 900)]
        let disk = DiskCache<[Indicator]>()
        disk.clearAll()
        disk.save(expected, for: "daily-indicators")
        
        let indicators = try await useCase.fetchDailyIndicators()
        XCTAssertEqual(indicators, expected)
    }
    
    func testHistoryFromAPI() async throws {
        let fakeHistory = ExchangeRateResponse(
            success: true,
            source: "CLP",
            startDate: "2025-01-01",
            endDate: "2025-01-05",
            quotes: ["2025-01-01" : ["CLPEUR": 1000.0]]
        )
        let mockAPI = MockAPIClient(responseHistory: fakeHistory)

        let useCase = FetchIndicatorsUseCase(api: mockAPI)
        
        let start = Date(timeIntervalSince1970: 1735689600) // 2025-01-01
        let end = Date(timeIntervalSince1970: 1736035200)   // 2025-01-05
        
        let history = try await useCase.fetchHistory(from: start, to: end)
        XCTAssertEqual(history.quotes["2025-01-01"]?["CLPEUR"], 1000.0)
    }
    
    func testHistoryFromDiskCache() async throws {
        let mockAPI = MockAPIClient()
        let useCase = FetchIndicatorsUseCase(api: mockAPI)
        
        let start = Date(timeIntervalSince1970: 1735689600)
        let end = Date(timeIntervalSince1970: 1736035200)
        let cacheKey = "\(start.timeIntervalSince1970)-\(end.timeIntervalSince1970)"
        
        let expected = ExchangeRateResponse(
            success: true,
            source: "CLP",
            startDate: "2025-01-01",
            endDate: "2025-01-05",
            quotes: ["2025-01-01" : ["CLPEUR": 1000.0]]
        )
        
        let disk = DiskCache<ExchangeRateResponse>()
        disk.clearAll()
        disk.save(expected, for: cacheKey)
        
        let history = try await useCase.fetchHistory(from: start, to: end)
        XCTAssertEqual(history.quotes["2025-01-01"]?["CLPEUR"], 1000.0)
    }
    
    func testDailyIndicatorsThrowsWhenAPIError() async {
        let disk = DiskCache<[Indicator]>()
        disk.clearAll()
        let mockAPI = MockAPIClient(shouldThrow: true)
        let useCase = FetchIndicatorsUseCase(api: mockAPI)

        do {
            _ = try await useCase.fetchDailyIndicators()
            XCTFail("Debería lanzar error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testHistoryThrowsWhenAPIError() async {
        let disk = DiskCache<[Indicator]>()
        disk.clearAll()
        let mockAPI = MockAPIClient(shouldThrow: true)
        let useCase = FetchIndicatorsUseCase(api: mockAPI)
        
        do {
            _ = try await useCase.fetchHistory(from: Date(), to: Date())
            XCTFail("Debería lanzar error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}

// MARK: - Mock API
actor MockAPIClient: APIClientProtocol {
    private let shouldThrow: Bool
    private let responseDaily: ExchangeResponse?
    private let responseHistory: ExchangeRateResponse?

    init(shouldThrow: Bool = false,
         responseDaily: ExchangeResponse? = nil,
         responseHistory: ExchangeRateResponse? = nil) {
        self.shouldThrow = shouldThrow
        self.responseDaily = responseDaily
        self.responseHistory = responseHistory
    }
    

    func request<T>(_ endpoint: Endpoint) async throws -> T where T: Decodable {

        if shouldThrow {
            throw NetworkError.requestFailed
        }

        if let endpoint = endpoint as? IndicatorEndpoint {
            switch endpoint {
            case .daily:
                guard let responseDaily, let casted = responseDaily as? T else {
                    throw NetworkError.decodingFailed
                }
                return casted

            case .history:
                guard let responseHistory, let casted = responseHistory as? T else {
                    throw NetworkError.decodingFailed
                }
                return casted
            }
        }

        throw NetworkError.invalidURL
    }
}
