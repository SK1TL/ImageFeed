//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 19.02.2024.
//

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String = ""
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard task == nil else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        let completionOnMainThread: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
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
                self.task = nil
                completionOnMainThread(.failure(error))
                
            }
        }
        self.task = task
        task.resume()
    }
}
