//
//  Constants.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 05.02.2024.
//

import Foundation

struct AuthConfiguration {
    var accessKey: String
    var secretKey: String
    var redirectURI: String
    var accessScope: String
    var defaultBaseURL: String
    var authURLString: String
    
    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: "oUYSD84d6vcJzSCmzbSYkjE0m-hQu0QZ9TfqRDybALs",
            secretKey: "Xcy5W2YFG55JEpWTOCwf29STNXIPDE9bxEHzUHIHozU",
            redirectURI: "urn:ietf:wg:oauth:2.0:oob",
            accessScope: "public+read_user+write_likes",
            defaultBaseURL: "https://api.unsplash.com",
            authURLString: "https://unsplash.com/oauth/authorize"
        )
    }
}
