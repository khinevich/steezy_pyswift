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
    
    // MARK: - GET all friends
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
    
    //MARK: - POST new friend
    func createFriend(_ friend: Friend) async throws -> Friend {
        guard let url = URL(string: "\(baseURL)/friends") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(friend)
        } catch {
            throw APIError.decodingError(error)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(Friend.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - PUT update friend
    func updateFriend(_ friend: Friend) async throws -> Friend {
        guard let url = URL(string: "\(baseURL)/friends/\(friend.id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(friend)
        } catch {
            throw APIError.decodingError(error)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(Friend.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - DELETE friend
        func deleteFriend(id: Int) async throws {
            guard let url = URL(string: "\(baseURL)/friends/\(id)") else {
                throw APIError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(httpResponse.statusCode)
            }
        }
}


