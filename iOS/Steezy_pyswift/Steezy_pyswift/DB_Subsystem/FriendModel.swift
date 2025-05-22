//
//  FriendModel.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 15.05.25.
//

import Foundation

struct Friend: Identifiable, Codable {
    var id: Int
    var name: String
    var surname: String
    var age: Int
    var sex: String
    var email: String
    var telephone: String
    var study: String
    
    
    var fullName: String {
        return "\(name) \(surname)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, surname, age, sex, email, telephone, study
    }
}

extension Friend {
    static var sampleFriends: [Friend] = [
        Friend(id: 1, name: "Mikhail", surname: "Khinevich", age: 25, sex: "male", email: "mikhail@gmail.com", telephone: "+79123456789", study: "IT"),
        Friend(id: 2, name: "Kirill" , surname: "Inosemtsev", age: 23, sex: "male", email: "kirill@tum.de", telephone: "+491621956224", study: "Wi-Info"),
        Friend(id: 3, name: "Ekaterina", surname: "Pavluichuk", age: 22, sex: "female", email: "katekate@gmail.com", telephone: "+79123456789", study: "MBT")
    ]
}
