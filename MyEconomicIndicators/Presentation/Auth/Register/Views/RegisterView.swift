//
//  RegisterView.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = RegisterViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos personales")) {
                    TextField("Nombre", text: $vm.user.firstName)
                    TextField("Apellido", text: $vm.user.lastName)
                }

                Section(header: Text("Credenciales")) {
                    TextField("Email", text: $vm.user.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    PasswordFieldView(password: $vm.user.password)
                    
                }

                Button("Registrarse") {
                    Task {
                        await vm.register()
                    }
                }

                switch vm.state {
                case .loading:
                    ProgressView()
                case .success:
                    Text("¡Registro exitoso!").foregroundColor(.green)
                case .failure(let error):
                    Text(error.localizedDescription).foregroundColor(.red)
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Registro")
        }
    }
}

#Preview {
    RegisterView()
}
