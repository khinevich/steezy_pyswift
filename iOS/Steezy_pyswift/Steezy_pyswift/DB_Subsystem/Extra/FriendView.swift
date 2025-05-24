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
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            if isEditing {
                TextField("Name", text: $friend.name)
                    .font(.title)
                    .multilineTextAlignment(.center)
                TextField("Surname", text: $friend.surname)
                    .font(.title2)
                    .multilineTextAlignment(.center)
            } else {
                Text(friend.fullName)
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
        
        VStack {
            if (isEditing) {
                //TextField("Age", text: $friend.age)
                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $friend.email)
                    TextField("Telephone", text: $friend.telephone)
                }
                Section(header: Text("Personal Information")) {
                    TextField("Age", value: $friend.age, format: .number)
                    TextField("Sex", text: $friend.sex)
                }
                Section(header: Text("Education")) {
                    TextField("Study", text: $friend.study)
                }
            }
            else {
                VStack {
                    Section(header: Text("Personal Information")) {
                        Text("Age: \(friend.age)")
                        Text("Sex: \(friend.sex)")
                    }
                    
                    Section(header: Text("Contact Information")) {
                        Text("Email: \(friend.email)")
                        Text("Telephone: \(friend.telephone)")
                    }
                    
                    Section(header: Text("Education")) {
                        Text("Study: \(friend.study)")
                    }
                }
            }
            if (isEditing){
                HStack {
                    Button(action: {
                        // Discard changes
                        self.friend = viewModel.friends.first(where: { $0.id == friend.id }) ?? friend
                        isEditing = false
                        print("Cancel")
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        Task {
                            //await viewModel.updateFriend(friend)
                            isEditing = false
                            print("Save Changes")
                        }
                    }) {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
            } else {
                Button(action: {
                    isEditing.toggle()
                    print("Edit")
                }) {
                    Text("Edit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    FriendView(friend: Friend(id: 1, name: "John", surname: "Doe", age: 25, sex: "Male",
                              email: "john.doe@example.com", telephone: "123-456-7890", study: "Computer Science"), viewModel: FriendViewModel())
}
