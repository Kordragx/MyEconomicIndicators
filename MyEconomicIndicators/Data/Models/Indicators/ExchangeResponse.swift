//
//  ExchangeResponse.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

struct ExchangeResponse: Codable {
    let success: Bool
    let source: String
    let quotes: [String: Double]
}
