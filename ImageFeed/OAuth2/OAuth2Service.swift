//
//  0Auth2Service.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 08.02.2024.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    private (set) var authToken: String? {
        get { OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue}
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = makeURL(code: code).url else {
            completion(.failure(NetworkErrors.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let fulfillCompletion: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let object = try? decoder.decode(ResponseBody.self, from: data) else {
                        fulfillCompletion(.failure(NetworkErrors.invalidDecoding))
                        return
                    }
                    let authToken = object.accessToken
                    self.authToken = authToken
                    fulfillCompletion(.success(authToken))
                }
                else {
                    fulfillCompletion(.failure(error ?? NetworkErrors.httpStatusCode(statusCode)))
                    return
                }
            }
        }
        task.resume()
    }
    
    private func makeURL(code: String) -> URLComponents {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        return urlComponents
    }
}
