//
//  LoginUserUseCase.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import Foundation

protocol LoginUserUseCase {
    func execute(email: String, password: String) async throws -> Bool
}

struct LiveLoginUserUseCase: LoginUserUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository = AuthRepositoryImpl()) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.emptyFields
        }

        return try await repository.login(email: email, password: password)
    }
}
