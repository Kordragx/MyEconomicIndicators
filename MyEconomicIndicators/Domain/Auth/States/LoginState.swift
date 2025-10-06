//
//  LoginState.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import Foundation

enum LoginState: Equatable {
    case idle
    case loading
    case success
    case failure(AuthError)
}
