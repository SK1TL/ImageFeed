//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 21.03.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    
    let configurator: AuthConfiguration
    
    init(configurator: AuthConfiguration = .standard) {
        self.configurator = configurator
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configurator.authURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI.rawValue),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope.rawValue)
        ]
        
        return urlComponents.url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
