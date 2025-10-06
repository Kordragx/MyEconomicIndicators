//
//  AuthError.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import Foundation

enum AuthError: LocalizedError {
    case userNotFound
    case invalidCredentials
    case emptyFields

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "No hay datos registrados. Por favor, regístrate."
        case .invalidCredentials:
            return "Credenciales incorrectas."
        case .emptyFields:
            return "Debes ingresar email y contraseña."
        }
    }
}
