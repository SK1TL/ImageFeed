//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 19.02.2024.
//

import UIKit

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String = ""
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard
            task == nil,
            let token = OAuth2TokenStorage.shared.token
        else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let completionOnMainThread: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case let .success(userResult):
                guard let avatarURL = userResult.profileImage?.small else { return }
                self.avatarURL = avatarURL
                completionOnMainThread(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL]
                    )
            case let .failure(error):
                completionOnMainThread(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
