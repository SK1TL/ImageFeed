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
    
    private init() {}
    
    func fetchPhotosNextPage(token: String) {
        if task == nil {
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            let request = imagesListRequest(token: token, page: nextPage)
            let task = urlSession.objectTask(
                for: request,
                completion: { [weak self] (result: Result<[PhotoResult], Error>) in
                    guard let self else { return }
                    switch result {
                    case let .success(PhotoResult):
                        photos.append(contentsOf: PhotoResult.map({Photo(photo: $0)}))
                        self.lastLoadedPage = nextPage
                        self.task = nil
                        NotificationCenter.default
                            .post(
                                name: ImagesListService.didChangeNotification,
                                object: self,
                                userInfo: ["Photos" : photos]
                            )
                    case .failure:
                        return
                    }
                }
            )
            self.task = task
            task.resume()
        }
    }
    
    func changeLike(
        _ token: String,
        photoId: String,
        isLike: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let request = changeLikeRequest(
            token: token,
            photoId: photoId,
            isLike: isLike
        )
        
        let task = urlSession.objectTask(
            for: request,
            completion: { [weak self] (result: Result<LikePhotoResult, Error>) in
                guard let self else { return }
                switch result {
                case let .success(photoResult):
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        photos[index] = Photo(photo: photoResult.photo)
                    }
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            })
        task.resume()
    }
    
    func resetPhotos() {
        photos = []
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
    
    func changeLikeRequest(token: String, photoId: String, isLike: Bool) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLike ? "DELETE" : "POST",
            baseURL: Constants.defaultBaseURL.rawValue
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
