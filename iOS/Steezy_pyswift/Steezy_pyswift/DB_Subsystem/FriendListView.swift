//
//  FriendListView.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 15.05.25.
//

import SwiftUI

struct FriendListView: View {
    @State private var viewModel = FriendViewModel()
    
    @State var sampleId = 4
    
    var body: some View {
        NavigationView {
            List {
                ForEach (viewModel.friends) {friend in
                        NavigationLink(destination: FriendView(friend: friend)) {
                            Text(friend.name)
                    }
                }
                .onDelete(perform: viewModel.deleteFriend)
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("adding friend")
                        viewModel.addFriend(Friend(id: sampleId , name: "New Friend", surname: "Surname", age: 25, sex: "male", email: "email@gmail.com", telephone: "+79123456789", study: "Study"))
                        self.sampleId += 1
                        
                        print(viewModel.friends)
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
