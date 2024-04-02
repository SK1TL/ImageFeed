//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 24.03.2024.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func fetchPhotosNextPage()
    func updateTableViewAnimated()
    func changeLike(indexPath: IndexPath)
    func setupNotificationObserver()
}

final class ImagesListPresenter {
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    private let tokenStorage = OAuth2TokenStorage.shared
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private func presentLikeAlert() {
        let alertModel = AlertModel(
            title: "Like error⚠️",
            message: "Не удалось поставить лайк😢",
            buttonText: "Try again!",
            error: nil,
            completion: nil
        )
        view?.presentAlert(model: alertModel)
    }
}

extension ImagesListPresenter: ImagesListPresenterProtocol {
    func fetchPhotosNextPage() {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        imagesListService.fetchPhotosNextPage(token: token)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }
    
    func changeLike(indexPath: IndexPath) {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let photo = photos[indexPath.row]
        imagesListService.changeLike(
            token,
            photoId: photo.id,
            isLike: photo.isLiked
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.dismissHUD()
            }
            guard let self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.view?.setCellIsLiked(by: indexPath, isLiked: !photo.isLiked)
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        let oldPhoto = photo
                        let newPhoto = Photo(
                            id: oldPhoto.id,
                            size: oldPhoto.size,
                            createdAt: oldPhoto.createdAt,
                            welcomeDescription: oldPhoto.welcomeDescription,
                            thumbImageURL: oldPhoto.thumbImageURL,
                            largeImageURL: oldPhoto.largeImageURL,
                            isLiked: !oldPhoto.isLiked
                        )
                        self.photos.remove(at: index)
                        self.photos.insert(newPhoto, at: index)
                    }
                }
            case .failure:
                presentLikeAlert()
            }
        }
    }
    
    func setupNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
    }
}
