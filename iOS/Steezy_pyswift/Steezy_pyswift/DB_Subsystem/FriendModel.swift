//
//  FriendModel.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 15.05.25.
//

import Foundation

@Observable class Friend: Identifiable {
    var id: Int
    var name: String
    var surname: String
    var age: Int
    var sex: String
    var email: String
    var telephone: String
    var study: String
    
    init(id: Int, name: String, surname: String, age: Int, sex: String, email: String, telephone: String, study: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.age = age
        self.sex = sex
        self.email = email
        self.telephone = telephone
        self.study = study
    }
    var fullName: String {
        return "\(name) \(surname)"
    }
}

extension Friend {
    static var sampleFriends: [Friend] = [
        Friend(id: 1, name: "Mikhail", surname: "Khinevich", age: 25, sex: "male", email: "mikhail@gmail.com", telephone: "+79123456789", study: "IT"),
        Friend(id: 2, name: "Kirill" , surname: "Inosemtsev", age: 23, sex: "male", email: "kirill@tum.de", telephone: "+491621956224", study: "Wi-Info"),
        Friend(id: 3, name: "Ekaterina", surname: "Pavluichuk", age: 22, sex: "female", email: "katekate@gmail.com", telephone: "+79123456789", study: "MBT")
    ]
}
