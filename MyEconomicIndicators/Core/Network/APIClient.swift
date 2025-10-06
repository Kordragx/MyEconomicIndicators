//
//  APIClient.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

actor APIClient: APIClientProtocol {
    private let apiKey: String

    init() {
        self.apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard var url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        // añadir apiKey
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "access_key", value: apiKey))
        components?.queryItems = queryItems
        url = components?.url ?? url

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.requestFailed
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

