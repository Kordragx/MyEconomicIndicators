//
//  Indicator.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation

struct Indicator: Identifiable, Codable, Equatable {
    var id = UUID()
    let pair: CurrencyPair
    let rawValue: Double
    
    var code: String { pair.rawValue }

    
    /// Valor invertido (para mostrar cuántos CLP equivale 1 unidad extranjera)
    var value: Double {
        1 / rawValue
    }
    
    /// Nombre legible para mostrar en UI
    var formattedName: String {
        pair.formattedName
    }
    
    /// Valor formateado en CLP, con separadores y símbolo
    var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = CurrencyPair.base
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

extension Indicator {
    static let dummyData: [Indicator] = [
        Indicator(pair: CurrencyPair.clpToUsd, rawValue: 0.00105), // 1 CLP = 0.00105 USD → 1 USD = ~952 CLP
        Indicator(pair: CurrencyPair.clpToEur, rawValue: 0.00089)  // 1 CLP = 0.00089 EUR → 1 EUR = ~1123 CLP
    ]
}
