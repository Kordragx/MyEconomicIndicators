//
//  AuthRepositoryImpl.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> Bool
}


final class AuthRepositoryImpl: AuthRepository {
    func login(email: String, password: String) async throws -> Bool {
        guard let storedEmail = KeychainService.shared.getValue(for: "userEmail"),
              let storedPasswordHash = KeychainService.shared.getValue(for: "userPassword") else {
            throw AuthError.userNotFound
        }

        let enteredPasswordHash = PasswordHasher.hash(password)

        guard email == storedEmail && enteredPasswordHash == storedPasswordHash else {
            throw AuthError.invalidCredentials
        }

        return true
    }
}

