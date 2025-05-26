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
    case httpError(Int, String)
    case encodingError(Error)
    case decodingError(Error)
    case networkError(Error)
    case noData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code, let message):
            return "HTTP error \(code): \(message)"
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "No data received from server"
        }
    }
}

class APIClient {
    private let baseURL = "http://localhost:8000"
    private let session = URLSession.shared
    
    // MARK: - Helper method to validate HTTP response
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        print("HTTP Response: \(httpResponse.statusCode)")
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            throw APIError.httpError(httpResponse.statusCode, errorMessage)
        }
    }
    
    // MARK: - GET all friends
    func fetchFriends() async throws -> [Friend] { //async let us continue working on the app while the tasks is executing
        guard let url = URL(string: "\(baseURL)/friends") else {
            throw APIError.invalidURL
        }
        print("Fetching friends from: \(url)")
        
        do {
            let (data, response) = try await session.data(from: url)
            try validateResponse(response)
            
            let friends = try JSONDecoder().decode([Friend].self, from: data)
            print("✅ Successfully fetched \(friends.count) friends")
            return friends
        } catch let error as APIError { // Catches errors that are already of type APIError
            print("XXXXXXXXXX   Error: \(error)")
            throw error
        } catch { // This is a catch-all block that catches any other error type
            print("XXXXXXXXXX   Error fetching friends: \(error)")
            throw APIError.networkError(error)
        }
    }
    // MARK: - GET single friend
    func fetchFriend(id: Int) async throws -> Friend {
        guard let url = URL(string: "\(baseURL)/friends") else {
            throw APIError.invalidURL
        }
        print("Fetching friend with \(id) from: \(url)")
        
        do {
            let (data, response) = try await session.data(from: url)
            try validateResponse(response)
            
            let friend = try JSONDecoder().decode(Friend.self, from: data)
            print("✅ Successfully fetched friend \(friend)")
            return friend
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
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
        
        var friendForCreation = friend
        friendForCreation.id = 1
        do {
            request.httpBody = try JSONEncoder().encode(friendForCreation)
        } catch {
            throw APIError.encodingError(error)
        }
        
        print("Creating friend: \(friendForCreation.fullName) at: \(url)")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            try validateResponse(response)
            
            let createdFriend = try JSONDecoder().decode(Friend.self, from: data)
            print("✅ Successfully created friend: \(createdFriend.fullName), ID: \(createdFriend.id)")
            return createdFriend
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
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
            throw APIError.encodingError(error)
        }
        
        print("Updating friend: \(friend.fullName)")
        
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
                    
            let updatedFriend = try JSONDecoder().decode(Friend.self, from: data)
            print("✅ Succesfsfully updated friend: \(updatedFriend.fullName)")
            
            return updatedFriend
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - DELETE friend
    func deleteFriend(id: Int) async throws {
        guard let url = URL(string: "\(baseURL)/friends/\(id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        print("Deleting friend with Id: \(id)")
        
        do {
            let (_, response) = try await session.data(for: request)
            try validateResponse(response)
            
            print("✅ Successfully deleted friend with Id: \(id)")
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}


