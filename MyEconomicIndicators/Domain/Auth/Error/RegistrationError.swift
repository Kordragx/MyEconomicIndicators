//
//  RegistrationError.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation

enum RegistrationError: LocalizedError {
    case emptyFields
    case invalidEmail
    case passwordTooShort
    case userAlreadyExists
    case coreDataError
    case unknown

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Todos los campos son obligatorios."
        case .invalidEmail:
            return "El correo electrónico no es válido."
        case .passwordTooShort:
            return "La contraseña debe tener al menos 6 caracteres."
        case .userAlreadyExists:
            return "El usuario ya está registrado."
        case .coreDataError:
            return "Error al guardar en la base de datos."
        case .unknown:
            return "Error desconocido"
        }
    }
}
