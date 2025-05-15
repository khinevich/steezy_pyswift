//
//  FriendView.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 15.05.25.
//

import SwiftUI

struct FriendView: View {
    
    @Bindable var friend: Friend
    var body: some View {
        VStack {
            Text("\(friend.name) \(friend.surname)")
            Text("\(friend.age) years old")
            Text("\(friend.sex)")
            Text("\(friend.email)")
            Text("\(friend.telephone)")
            Text("\(friend.study)")
        }
    }
}

#Preview {
    FriendView(friend: Friend(id: 1, name: "John", surname: "Doe", age: 25, sex: "Male",
                              email: "john.doe@example.com", telephone: "123-456-7890", study: "Computer Science"))
}
