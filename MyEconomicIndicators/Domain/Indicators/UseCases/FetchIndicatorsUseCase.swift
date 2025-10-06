//
//  FetchIndicatorsUseCase.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import Foundation
actor FetchIndicatorsUseCase {
    private let api: APIClientProtocol
    private let cacheIndicators = MemoryCache<String, [Indicator]>()
    private let cacheHistory = MemoryCache<String, ExchangeRateResponse>()
    private let diskCacheIndicators = DiskCache<[Indicator]>()
    private let diskCacheHistory = DiskCache<ExchangeRateResponse>()

    init(api: APIClientProtocol = APIClient()) {
        self.api = api
    }

    func fetchDailyIndicators() async throws -> [Indicator] {
        let cacheKey = "daily-indicators"

        if let cached = cacheIndicators.get(cacheKey) {
            return cached
        }
        if let diskCached = diskCacheIndicators.load(for: cacheKey) {
            cacheIndicators.set(cacheKey, value: diskCached)
            return diskCached
        }

        let raw: ExchangeResponse = try await api.request(IndicatorEndpoint.daily)

        let indicators: [Indicator] = CurrencyPair.allCases.compactMap { pair in
            guard let value = raw.quotes[pair.rawValue] else { return nil }
            return Indicator(pair: pair, rawValue: value)
        }

        cacheIndicators.set(cacheKey, value: indicators)
        diskCacheIndicators.save(indicators, for: cacheKey)
        return indicators
    }

    func fetchHistory(from startDate: Date, to endDate: Date) async throws -> ExchangeRateResponse {
        let formatter = DateUtils.dateFormatter
        let fromString = formatter.string(from: startDate)
        let toString = formatter.string(from: endDate)

        let cacheKey = "\(startDate.timeIntervalSince1970)-\(endDate.timeIntervalSince1970)"

        if let cached = cacheHistory.get(cacheKey) { return cached }
        if let diskCached = diskCacheHistory.load(for: cacheKey) {
            cacheHistory.set(cacheKey, value: diskCached)
            return diskCached
        }

        let response: ExchangeRateResponse = try await api.request(
            IndicatorEndpoint.history(start: fromString, end: toString)
        )

        cacheHistory.set(cacheKey, value: response)
        diskCacheHistory.save(response, for: cacheKey)
        return response
    }
}
