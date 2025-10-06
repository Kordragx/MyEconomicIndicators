//
//  LoginViewModel.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var state: LoginState = .idle

    private let loginUseCase: LoginUserUseCase

    init(loginUseCase: LoginUserUseCase = LiveLoginUserUseCase()) {
        self.loginUseCase = loginUseCase
    }

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            state = .failure(AuthError.emptyFields)
            return
        }

        state = .loading
        do {
            let success = try await loginUseCase.execute(email: email, password: password)
            state = success ? .success : .failure(AuthError.invalidCredentials)
        } catch {
            state = .failure(AuthError.userNotFound)
        }
    }
}
