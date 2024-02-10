//
//  0AuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 08.02.2024.
//

import Foundation

struct ResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: String
}
