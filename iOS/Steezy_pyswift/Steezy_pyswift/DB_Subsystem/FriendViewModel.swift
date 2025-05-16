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
    init() {
        loadSampleFriends()
    }
    
    func loadSampleFriends() {
        friends.append(contentsOf: Friend.sampleFriends)
        
        // TODO fetching data from DB
    }
    
    // CRUD Methods
    func addFriend(_ friend: Friend) {
        friends.append(friend)
    }
    
    func deleteFriend(at indexSet: IndexSet) {
        friends.remove(atOffsets: indexSet)
    }
    
    func updateFriend(){
        print("TODO Update friend")
    }
}
