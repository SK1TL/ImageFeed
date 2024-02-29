//
//  NetworkErrors.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 09.02.2024.
//

import Foundation

extension URLSession {
    enum NetworkErrors: Error {
        case invalidUrl
        case httpStatusCode(Int)
        case invalidDecoding
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    let decoder = JSONDecoder()
                    guard let object = try? decoder.decode(T.self, from: data) else {
                        completion(.failure(NetworkErrors.invalidDecoding))
                        return
                    }
                    completion(.success(object))
                } else {
                    completion(.failure(error ?? NetworkErrors.httpStatusCode(statusCode)))
                    return
                }
            }
        }
        return task
    }
}
