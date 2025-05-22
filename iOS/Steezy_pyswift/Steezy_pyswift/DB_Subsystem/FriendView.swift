//
//  FriendView.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 15.05.25.
//

import SwiftUI

struct FriendView: View {
    
    @State var friend: Friend
    @Bindable var viewModel: FriendViewModel
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            if (isEditing) {
                TextField("Name", text: $friend.name)
                TextField("Surname", text: $friend.surname)
                //TextField("Age", text: $friend.age)
                TextField("sex", text: $friend.sex)
                TextField("email", text: $friend.email)
                TextField("telephone", text: $friend.telephone)
                TextField("study", text: $friend.study)
            }
            else {
                VStack {
                    Text("\(friend.name) \(friend.surname)")
                    Text("\(friend.age) years old")
                    Text("\(friend.sex)")
                    Text("\(friend.email)")
                    Text("\(friend.telephone)")
                    Text("\(friend.study)")
                }
            }
            if (isEditing){
                HStack {
                    Button(action: {
                        isEditing.toggle()
                    }, label:{
                        Text("Save")
                    })
                    Button(action: {
                        isEditing.toggle()
                    }, label:{
                        Text("Cancel")
                    })
                }
            } else {
                Button(action: {
                    isEditing.toggle()
                }, label:{
                    Text("Edit")
                })
            }
        }
    }
}

#Preview {
    FriendView(friend: Friend(id: 1, name: "John", surname: "Doe", age: 25, sex: "Male",
                              email: "john.doe@example.com", telephone: "123-456-7890", study: "Computer Science"), viewModel: FriendViewModel())
}
