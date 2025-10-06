//
//  PasswordFieldView.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import SwiftUICore
import SwiftUI

struct PasswordFieldView: View {
    @Binding var password: String
    @State private var isSecure: Bool = true
    
    var body: some View {
        HStack {
            Group {
                if isSecure {
                    SecureField("Contraseña", text: $password)
                } else {
                    TextField("Contraseña", text: $password)
                }
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            if !$password.wrappedValue.isEmpty {
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            
        }
    }
}
