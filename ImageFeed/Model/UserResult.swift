//
//  UserResult.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 26.02.2024.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String?
}

