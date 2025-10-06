//
//  CurrencyPair.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


enum CurrencyPair: String, CaseIterable, Identifiable, Codable {
    case clpToUsd = "CLPUSD"
    case clpToEur = "CLPEUR"

    var id: String { rawValue }

    var formattedName: String {
        switch self {
        case .clpToUsd: return "Dólar"
        case .clpToEur: return "Euro"
        }
    }

    var symbol: String {
        switch self {
        case .clpToUsd: return "USD"
        case .clpToEur: return "EUR"
        }
    }

    static var base: String {
        "CLP"
    }


    var target: String {
        String(rawValue.dropFirst(3)) // Remove "CLP"
    }
}

extension CurrencyPair {
    static func formattedName(for code: String) -> String {
        switch code {
        case clpToUsd.rawValue: return "Dólar (USD → CLP)"
        case clpToEur.rawValue: return "Euro (EUR → CLP)"
        default: return code
        }
    }
}
