//
//  FriendViewModel.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 16.05.25.
//

import Foundation
import SwiftUI

@Observable class FriendViewModel {
    var friends = [Friend]()
    private let apiClient = APIClient()
    
    init() {
        Task {
            await initiWithSampleFriends()
        }
    }
    
    @MainActor
    private func initiWithSampleFriends() async {
        for sampleFriend in Friend.sampleFriends {
            do {
                let createdFriend = try await apiClient.createFriend(sampleFriend)
                friends.append(createdFriend)
            } catch {
                print("XXXXXXXXXXXX  Error adding sample friend: \(sampleFriend.fullName)")
            }
        }
        Task {
            await loadFriendsFromAPI()
        }
        friends.append(contentsOf: Friend.sampleFriends)
    }
    @MainActor
    func loadFriendsFromAPI() async {
        // TODO fetching data from DB
        do {
            friends = try await apiClient.fetchFriends()
        } catch {
            print("XXXXXXXXXX   Error loading friends \(error.localizedDescription)")
        }
    }
    
    // CRUD Methods
    @MainActor
    func addFriend(_ friend: Friend) async {
        do {
            let createdFriend = try await apiClient.createFriend(friend)
            friends.append(createdFriend)
        } catch {
            print("XXXXXXXXXX     Error creating friends \(error.localizedDescription)")
        }
        
    }
    
    @MainActor
    func deleteFriend(at indexSet: IndexSet) async {
        for index in indexSet {
            
            let friend = friends[index]
            friends.remove(at: index)
            Task {
                do {
                    try await apiClient.deleteFriend(id: friend.id)
                } catch {
                    print("XXXXXXXXX      Error deleting friend \(error.localizedDescription)")
                    await loadFriendsFromAPI()
                }
            }
        }
        printAllFriends()
    }
    
    @MainActor
    func updateFriend(_ updatedFriend: Friend) async {
        do {
            let returnedFriend = try await apiClient.updateFriend(updatedFriend)
            
            if let index = friends.firstIndex(where: {$0.id == returnedFriend.id}){
                friends[index] = returnedFriend
            } else {
                print("No id found: \(returnedFriend.id)")
            }
        } catch {
            print("XXXXXXXXXXX    Error updating friend \(error.localizedDescription)")
        }
    }
    
    func refreshFriends() {
        Task {
            await loadFriendsFromAPI()
        }
    }
    
    // MARK: - for debug purposes
    func printAllFriends() {
        print("\n--- Current Friends List ---")
        for friend in friends{
            print("ID: \(friend.id), Name: \(friend.fullName), Email: \(friend.email)")
        }
        print("-----------------")
    }
}
