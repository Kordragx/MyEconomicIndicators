//
//  Endpoint.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//


import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                       resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url
    }
}
