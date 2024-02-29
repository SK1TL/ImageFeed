//
//  Profile.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 19.02.2024.
//

import Foundation

struct Profile {
    let userName: String
    let firstName: String
    let lastName: String
    var name: String {
        return firstName + " " + lastName
    }
    var loginName: String {
        return "@" + userName
    }
    var bio: String
}
