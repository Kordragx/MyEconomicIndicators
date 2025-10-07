//
//  LoginView.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(spacing: 8) {
                    Text("Mis Indicadores Económicos")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)

                    Rectangle()
                        .fill(Color.accentColor.opacity(0.8))
                        .frame( height: 3 )
                        .padding(.horizontal, 16)
                        .cornerRadius(1.5)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 12)

                VStack(spacing: 20) {
                    TextField("Correo electrónico", text: $vm.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .onChange(of: vm.password) { _ in
                            if case .failure = vm.state {
                                vm.state = .idle
                            }
                        }

                    PasswordFieldView(password: $vm.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .onChange(of: vm.email) { _ in
                            if case .failure = vm.state {
                                vm.state = .idle
                            }
                        }

                    contentForState()
                    
                    NavigationLink("¿No tienes cuenta? Regístrate", destination: RegisterView())
                        .font(.footnote)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationDestination(isPresented: $isLoggedIn) {
                IndicatorsView(vm: IndicatorsViewModel())
            }
            .onChange(of: vm.state) { newState in
                if newState == .success {
                    isLoggedIn = true
                }
            }
        }
    }

    // MARK: - Subview según estado
    @ViewBuilder
    private func contentForState() -> some View {
        switch vm.state {
        case .idle:
            loginButton
        case .loading:
            ProgressView("Verificando credenciales…")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        case .success:
            EmptyView()
        case .failure(let error):
            Text(error.localizedDescription)
                .foregroundColor(.red)
                .font(.footnote)
                .transition(.opacity)
        }
        

    }

    private var loginButton: some View {
        Button {
            Task { await vm.login() }
        } label: {
            Text("Ingresar")
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 36)
        .buttonStyle(.borderedProminent)
        .disabled(vm.email.isEmpty || vm.password.isEmpty)
        .padding(.top, 10)
    }
}

#Preview {
    LoginView()
}
