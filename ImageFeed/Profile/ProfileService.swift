//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 19.02.2024.
//

import Foundation

final class ProfileService {
   
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        guard task == nil else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let completionOnMainThread: (Result<Profile, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case let .success(profile):
                self.profile = Profile(
                    userName: profile.userName,
                    firstName: profile.firstName,
                    lastName: profile.lastName ?? "",
                    bio: profile.bio ?? ""
                )
                completionOnMainThread(.success(self.profile!))
            case let .failure(error):
                completionOnMainThread(.failure(error))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
