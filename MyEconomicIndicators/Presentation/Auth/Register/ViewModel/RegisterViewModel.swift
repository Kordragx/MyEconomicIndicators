//
//  RegisterViewModel.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import Foundation
import CoreData

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var user = RegisterUserModel()
    @Published var state: RegistrationState = .idle

    private let registerUseCase: RegisterUserUseCase

    init(registerUseCase: RegisterUserUseCase = LiveRegisterUserUseCase()) {
        self.registerUseCase = registerUseCase
    }

    func register() async {
        guard validateFields() else { return }

        state = .loading
        do {
            try await registerUseCase.execute(with: user)
            state = .success
            cleanRegisterForm()
        } catch let error as RegistrationError {
            state = .failure(error)
        } catch {
            state = .failure(.unknown)
        }
    }

    private func validateFields() -> Bool {
        guard !user.firstName.isEmpty,
              !user.lastName.isEmpty,
              !user.email.isEmpty,
              !user.password.isEmpty else {
            state = .failure(.emptyFields)
            return false
        }

        guard user.email.contains("@"), user.email.contains(".") else {
            state = .failure(.invalidEmail)
            return false
        }

        guard user.password.count >= 6 else {
            state = .failure(.passwordTooShort)
            return false
        }

        return true
    }
    
    private func cleanRegisterForm() {
        user = RegisterUserModel()
    }
}
