//
//  APIHelper.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidEndpoint
    case decodeFailure
    case invalidCredentials
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEndpoint:
            return "Invalid API Endpoint."
        case .decodeFailure:
            return "Failed to decode the response."
        case .invalidCredentials:
            return "Invalid username or password."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .serverError(let message):
            return "Server Error: \(message)"
        }
    }
}

public protocol APIServiceProtocol {
    func performRequest<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) async throws -> T
}

public class APIHelper: APIServiceProtocol {
    
    static let shared = APIHelper()
    
    private init() {}
    
    private func getAuthHeaders() -> String? {
        guard let apiKey = KeychainHelper.shared.read(key: "apiKey") else { return nil }
        return apiKey
    }

    public func performRequest<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        let request = try endpoint.makeRequest()
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(jsonString)")
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
