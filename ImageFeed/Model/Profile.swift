//
//  Profile.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 19.02.2024.
//

import Foundation

public struct Profile {
    let userName: String
    let firstName: String
    let lastName: String
    var name: String {
        firstName + " " + lastName
    }
    var loginName: String {
        "@" + userName
    }
    var bio: String
}
