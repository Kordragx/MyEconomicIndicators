//
//  MockLoginUseCase.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import XCTest
@testable import MyEconomicIndicators

// MARK: - Mock Login UseCase
final class MockLoginUseCase: LoginUserUseCase {
    var shouldSucceed = false
    var shouldThrow = false
    
    func execute(email: String, password: String) async throws -> Bool {
        if shouldThrow { throw AuthError.userNotFound }
        return shouldSucceed
    }
}

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    func testLoginWithEmptyFields() async {
        let vm = LoginViewModel(loginUseCase: MockLoginUseCase())
        
        await vm.login()
        
        if case .failure(let error) = vm.state {
            XCTAssertEqual(error, .emptyFields)
        } else {
            XCTFail("Se esperaba estado .failure(.emptyFields)")
        }
    }
    
    func testSuccessfulLogin() async {
        let mock = MockLoginUseCase()
        mock.shouldSucceed = true
        let vm = LoginViewModel(loginUseCase: mock)
        vm.email = "test@mail.com"
        vm.password = "123456"
        
        await vm.login()
        
        XCTAssertEqual(vm.state, .success)
    }
    
    func testFailedLoginInvalidCredentials() async {
        let mock = MockLoginUseCase()
        mock.shouldSucceed = false
        let vm = LoginViewModel(loginUseCase: mock)
        vm.email = "wrong@mail.com"
        vm.password = "badpass"
        
        await vm.login()
        
        if case .failure(let error) = vm.state {
            XCTAssertEqual(error, .invalidCredentials)
        } else {
            XCTFail("Se esperaba estado .failure(.invalidCredentials)")
        }
    }
    
    func testLoginThrowsErrorUserNotFound() async {
        let mock = MockLoginUseCase()
        mock.shouldThrow = true
        let vm = LoginViewModel(loginUseCase: mock)
        vm.email = "notfound@mail.com"
        vm.password = "secret"
        
        await vm.login()
        
        if case .failure(let error) = vm.state {
            XCTAssertEqual(error, .userNotFound)
        } else {
            XCTFail("Se esperaba estado .failure(.userNotFound)")
        }
    }
}
