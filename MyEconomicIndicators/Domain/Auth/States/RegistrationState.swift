//
//  RegistrationState.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

enum RegistrationState: Equatable {
    case idle
    case loading
    case success
    case failure(RegistrationError)
    case unknown
}
