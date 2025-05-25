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
    let sexOptions = ["male", "female"]
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            if isEditing {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Name", text: $friend.name)
                        TextField("Surname", text: $friend.surname)
                        TextField("Age", value: $friend.age, format: .number)
                            .keyboardType(.numberPad)
                        Picker("Sex", selection: $friend.sex) {
                            ForEach(sexOptions, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    Section(header: Text("Contact Information")) {
                        TextField("Email", text: $friend.email)
                            .keyboardType(.emailAddress)
                        TextField("Telephone", text: $friend.telephone)
                            .keyboardType(.phonePad)
                    }
                    
                    Section(header: Text("Education")) {
                        TextField("Study", text: $friend.study)
                    }
                }
            } else {
                Form {
                    Section(header: Text("Personal Information")) {
                        Text(friend.name)
                        Text(friend.surname)
                        Text(friend.age.description)
                        Text(friend.sex)
                    }
                    Section(header: Text("Contact Information")) {
                        Text(friend.email)
                            .keyboardType(.emailAddress)
                        Text(friend.telephone)
                            .keyboardType(.phonePad)
                    }
                    
                    Section(header: Text("Education")) {
                        Text(friend.study)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
        
        // BUTTONS
        if (isEditing){
            HStack {
                Button(action: {
                    // Discard changes
                    self.friend = viewModel.friends.first(where: { $0.id == friend.id }) ?? friend
                    isEditing = false
                    print("Cancel")
                }) {
                    Text("Cancel")
                        .frame(maxWidth: 150)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    Task {
                        viewModel.updateFriend(friend)
                        isEditing = false
                        print("Save Changes")
                        print(friend)
                        print(viewModel.friends)
                    }
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: 150)
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
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
    }

}

#Preview {
    FriendView(friend: Friend(id: 1, name: "John", surname: "Doe", age: 25, sex: "Male",
                              email: "john.doe@example.com", telephone: "123-456-7890", study: "Computer Science"), viewModel: FriendViewModel())
}
