//
//  RegisterUserUseCase.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


protocol RegisterUserUseCase {
    func execute(with user: RegisterUserModel) async throws
}

struct LiveRegisterUserUseCase: RegisterUserUseCase {
    private let repository: UserRepository

    init(repository: UserRepository = UserRepositoryImpl()) {
        self.repository = repository
    }

    func execute(with user: RegisterUserModel) async throws {
        try await repository.register(user)
    }
}
