//
//  MockRegisterUseCase.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


//
//  RegisterViewModelTests.swift
//  MyEconomicIndicatorsTests
//
//  Created by Daniel Nunez on 06-10-25.
//

import XCTest
@testable import MyEconomicIndicators

// MARK: - Mock Register UseCase
final class MockRegisterUseCase: RegisterUserUseCase {
    var shouldThrow = false
    
    func execute(with user: RegisterUserModel) async throws {
        if shouldThrow {
            throw RegistrationError.unknown
        }
    }
}

@MainActor
final class RegisterViewModelTests: XCTestCase {
    
    func testRegisterWithEmptyFields() async {
        let vm = RegisterViewModel(registerUseCase: MockRegisterUseCase())
        await vm.register()
        XCTAssertEqual(vm.state, .failure(.emptyFields))
    }
    
    func testRegisterWithInvalidEmail() async {
        let vm = RegisterViewModel(registerUseCase: MockRegisterUseCase())
        vm.user = RegisterUserModel(firstName: "Dani", lastName: "Nuñez", email: "bademail", password: "123456")
        await vm.register()
        XCTAssertEqual(vm.state, .failure(.invalidEmail))
    }
    
    func testRegisterWithShortPassword() async {
        let vm = RegisterViewModel(registerUseCase: MockRegisterUseCase())
        vm.user = RegisterUserModel(firstName: "Dani", lastName: "Nuñez", email: "good@mail.com", password: "12")
        await vm.register()
        XCTAssertEqual(vm.state, .failure(.passwordTooShort))
    }
    
    func testSuccessfulRegistration() async {
        let mock = MockRegisterUseCase()
        let vm = RegisterViewModel(registerUseCase: mock)
        vm.user = RegisterUserModel(firstName: "Dani", lastName: "Nuñez", email: "good@mail.com", password: "123456")
        
        await vm.register()
        XCTAssertEqual(vm.state, .success)
        XCTAssertEqual(vm.user, RegisterUserModel(), "El formulario debería resetearse")
    }
    
    func testRegistrationThrowsError() async {
        let mock = MockRegisterUseCase()
        mock.shouldThrow = true
        let vm = RegisterViewModel(registerUseCase: mock)
        vm.user = RegisterUserModel(firstName: "Dani", lastName: "Nuñez", email: "good@mail.com", password: "123456")
        
        await vm.register()
        XCTAssertEqual(vm.state, .failure(.unknown))
    }
}
