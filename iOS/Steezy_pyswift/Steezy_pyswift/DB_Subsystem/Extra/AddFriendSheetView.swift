//
//  AddFriendSheetView.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 23.05.25.
//

import SwiftUI

struct AddFriendSheetView: View {
    @Bindable var viewModel: FriendViewModel
    @Binding var isPresented: Bool
    @Binding var sampleId: Int
    
    @State private var name = ""
    @State private var surname = ""
    @State private var age = ""
    @State private var sex = "male"
    @State private var email = ""
    @State private var telephone = ""
    @State private var study = ""
    
    let sexOptions = ["male", "female", "other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Surname", text: $surname)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    Picker("Sex", selection: $sex) {
                        ForEach(sexOptions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Telephone", text: $telephone)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Education")) {
                    TextField("Study", text: $study)
                }
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveFriend()
                    }
                    .disabled(name.isEmpty || surname.isEmpty)
                }
            }
        }
    }
    
    private func saveFriend() {
        let ageInt = Int(age) ?? 0
        
        let newFriend = Friend(
            id: sampleId, // Backend will assign real ID
            name: name,
            surname: surname,
            age: ageInt,
            sex: sex,
            email: email,
            telephone: telephone,
            study: study
        )
        
        Task {
            await viewModel.addFriend(newFriend)
            print("adding friend")
            //viewModel.addFriend(Friend(id: sampleId , name: "New Friend", surname: "Surname", age: 25, sex: "male", email: "email@gmail.com", telephone: "+79123456789", study: "Study"))
            self.sampleId += 1
            
            print(viewModel.friends)
            
            isPresented = false
        }
    }
    
}

#Preview {
    AddFriendSheetView(viewModel: FriendViewModel(), isPresented: .constant(true), sampleId: .constant(1) )
}
