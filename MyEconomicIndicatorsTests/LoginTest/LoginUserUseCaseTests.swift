//
//  MockAuthRepository.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


//
//  LoginUserUseCaseTests.swift
//  MyEconomicIndicatorsTests
//
//  Created by Daniel Nunez on 06-10-25.
//

import XCTest
@testable import MyEconomicIndicators

// MARK: - Mock Repository
final class MockAuthRepository: AuthRepository {
    var shouldThrow = false
    var shouldReturnTrue = false
    
    func login(email: String, password: String) async throws -> Bool {
        if shouldThrow {
            throw AuthError.invalidCredentials
        }
        return shouldReturnTrue
    }
}

// MARK: - Tests
final class LoginUserUseCaseTests: XCTestCase {
    
    func testExecuteWithEmptyFieldsThrowsError() async {
        let useCase = LiveLoginUserUseCase(repository: MockAuthRepository())
        
        do {
            _ = try await useCase.execute(email: "", password: "")
            XCTFail("Debería lanzar AuthError.emptyFields")
        } catch let error as AuthError {
            XCTAssertEqual(error, .emptyFields)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }
    
    func testExecuteSuccessfulLogin() async throws {
        let mockRepo = MockAuthRepository()
        mockRepo.shouldReturnTrue = true
        let useCase = LiveLoginUserUseCase(repository: mockRepo)
        
        let result = try await useCase.execute(email: "test@mail.com", password: "1234")
        XCTAssertTrue(result, "El login debería ser exitoso")
    }
    
    func testExecuteFailedLogin() async throws {
        let mockRepo = MockAuthRepository()
        mockRepo.shouldReturnTrue = false
        let useCase = LiveLoginUserUseCase(repository: mockRepo)
        
        let result = try await useCase.execute(email: "wrong@mail.com", password: "xxxx")
        XCTAssertFalse(result, "El login debería fallar con credenciales inválidas")
    }
    
    func testExecuteRepositoryThrowsError() async {
        let mockRepo = MockAuthRepository()
        mockRepo.shouldThrow = true
        let useCase = LiveLoginUserUseCase(repository: mockRepo)
        
        do {
            _ = try await useCase.execute(email: "test@mail.com", password: "bad")
            XCTFail("Debería lanzar AuthError.invalidCredentials")
        } catch let error as AuthError {
            XCTAssertEqual(error, .invalidCredentials)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }
}
