//
//  Constants.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 05.02.2024.
//

import Foundation

struct Constants {
    static let accessKey = "oUYSD84d6vcJzSCmzbSYkjE0m-hQu0QZ9TfqRDybALs"
    static let secretKey = "Xcy5W2YFG55JEpWTOCwf29STNXIPDE9bxEHzUHIHozU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

