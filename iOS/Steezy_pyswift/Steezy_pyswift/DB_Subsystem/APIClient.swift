//
//  APIClient.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 22.05.25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)
    case unknown
}

class APIClient {
    private let baseURL = "http://localhost:8000"
    
    func fetchFriends() async throws -> [Friend] { //async let us continue working on the app while the tasks is executing
        guard let url = URL(string: "\(baseURL)/friends") else {
            throw APIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode([Friend].self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}


