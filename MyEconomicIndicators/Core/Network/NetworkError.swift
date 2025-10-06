//
//  NetworkError.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida"
        case .requestFailed: return "La solicitud falló"
        case .decodingFailed: return "Error al decodificar los datos"
        }
    }
}
