//
//  MockUserRepository.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import XCTest
@testable import MyEconomicIndicators

// MARK: - Mock Repository
final class MockUserRepository: UserRepository {
    var shouldThrow = false
    
    func register(_ user: RegisterUserModel) async throws {
        if shouldThrow {
            throw RegistrationError.userAlreadyExists
        }
    }
}

// MARK: - Tests
final class RegisterUserUseCaseTests: XCTestCase {
    
    func testExecuteSuccessfulRegistration() async throws {
        let mockRepo = MockUserRepository()
        let useCase = LiveRegisterUserUseCase(repository: mockRepo)
        
        let user = RegisterUserModel(
            firstName: "Dani",
            lastName: "Nuñez",
            email: "test@mail.com",
            password: "1234"
        )
        
        // no debería lanzar
        try await useCase.execute(with: user)
    }
    
    func testExecuteRegistrationFails() async {
        let mockRepo = MockUserRepository()
        mockRepo.shouldThrow = true
        let useCase = LiveRegisterUserUseCase(repository: mockRepo)
        
        let user = RegisterUserModel(
            firstName: "Dani",
            lastName: "Nuñez",
            email: "test@mail.com",
            password: "1234"
        )
        
        do {
            try await useCase.execute(with: user)
            XCTFail("Debería lanzar AuthError.emailAlreadyExists")
        } catch let error as RegistrationError {
            XCTAssertEqual(error, .userAlreadyExists)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }
}
