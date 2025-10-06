//
//  ApiStates.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


enum APIState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var data: T? {
        if case let .success(value) = self { return value }
        return nil
    }

    var error: Error? {
        if case let .failure(error) = self { return error }
        return nil
    }
}
