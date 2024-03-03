//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 29.02.2024.
//

import Foundation


final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    
     init() {}
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        if task == nil {
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            let request = imagesListRequest(token: token, page: nextPage)
            let task = urlSession.objectTask(
                for: request,
                completion: {[weak self] (result: Result<[PhotoResult], Error>) in
                guard let self else { return }
                switch result {
                case  let .success(PhotoResult):
                    photos.append(contentsOf: PhotoResult.map({Photo(photo: $0)}))
                    self.lastLoadedPage = nextPage
                    self.task = nil
                    completion(.success(photos))
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Photos" : photos])
                case let .failure(error):
                    completion(.failure(error))
                }
            })
            self.task = task
            task.resume()
        }
    }
}

extension ImagesListService {
    func imagesListRequest(token: String, page: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)",
            httpMethod: "GET",
            baseURL: Constants.defaultBaseURL.rawValue
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
