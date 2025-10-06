//
//  ExchangeRateResponse.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import Foundation

struct ExchangeRateResponse: Codable {
    let success: Bool
    let source: String
    let startDate: String
    let endDate: String
    let quotes: [String: [String: Double]]

    enum CodingKeys: String, CodingKey {
        case success, source, quotes
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct DailyRate: Identifiable {
    let id = UUID()
    let date: Date
    let rawValue: Double
    
    var value: Double {
        1 / rawValue
    }
    
    /// Valor formateado en CLP, con separadores y símbolo
    var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "CLP"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
