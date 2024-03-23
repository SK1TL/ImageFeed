//
//  Constants.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 05.02.2024.
//

import Foundation

enum Constants: String {
    case accessKey = "oUYSD84d6vcJzSCmzbSYkjE0m-hQu0QZ9TfqRDybALs"
    case secretKey = "Xcy5W2YFG55JEpWTOCwf29STNXIPDE9bxEHzUHIHozU"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    case accessScope = "public+read_user+write_likes"
    
    case defaultBaseURL = "https://api.unsplash.com"
    case unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: String,
        authURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey.rawValue,
            secretKey: Constants.secretKey.rawValue,
            redirectURI: Constants.redirectURI.rawValue,
            accessScope: Constants.accessScope.rawValue,
            defaultBaseURL: Constants.defaultBaseURL.rawValue,
            authURLString: Constants.unsplashAuthorizeURLString.rawValue
        )
    }
}
