//
//  FriendListView.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 15.05.25.
//

import SwiftUI

struct FriendListView: View {
    
    let friends = Friend.sampleFriends
    
    var body: some View {
        NavigationView {
            List {
                ForEach (friends) {friend in
                        NavigationLink(destination: FriendView(friend: friend)) {
                        Text(friend.name)
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                            print("adding friend")
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    FriendListView()
}
