//
//  IndicatorEndpoint.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation

enum IndicatorEndpoint: Endpoint {
    case daily
    case history(start: String, end: String)

    var baseURL: URL { URL(string: "https://api.exchangerate.host")! }

    var path: String {
        switch self {
        case .daily: return "live"
        case .history: return "timeframe"
        }
    }

    var method: String { "GET" }

    var queryItems: [URLQueryItem] {
        switch self {
        case .daily:
            return [
                URLQueryItem(name: "source", value: "CLP"),
                URLQueryItem(name: "currencies", value: "USD,EUR")
            ]
        case .history(let start, let end):
            return [
                URLQueryItem(name: "source", value: "CLP"),
                URLQueryItem(name: "currencies", value: "USD,EUR"),
                URLQueryItem(name: "start_date", value: start),
                URLQueryItem(name: "end_date", value: end)
            ]
        }
    }
}
