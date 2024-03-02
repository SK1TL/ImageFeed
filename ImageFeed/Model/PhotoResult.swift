//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 02.03.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    
    init(photo: PhotoResult) {
        id = photo.id
        size = CGSize(width: photo.width, height: photo.height)
        createdAt = Date.dateFromString(photo.createdAt)
        welcomeDescription = photo.description
        thumbImageURL = photo.urls.thumb
        largeImageURL = photo.urls.large
        isLiked = photo.likeByUser
    }
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let likeByUser: Bool
    let width: Int
    let height: Int
    let description: String?
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case likeByUser = "liked_by_user"
        case width
        case height
        case description = "description"
        case urls
    }
}

struct UrlsResult: Decodable {
    let large: String
    let thumb: String
    
    
    enum CodingKeys: String, CodingKey {
        case large = "full"
        case thumb
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}
