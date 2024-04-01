//
//  URLRequest+Extension.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 26.02.2024.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: String = AuthConfiguration.standard.defaultBaseURL
    ) -> URLRequest {
        guard
            let baseURL = URL(string: baseURL),
            let url = URL(string: path, relativeTo: baseURL)
        else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
