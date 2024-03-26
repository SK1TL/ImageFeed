//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Артур Гайфуллин on 25.03.2024.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
        var fetchPhotosNextPageCalled: Bool = false
        var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func updateTableViewAnimated() {
        
    }
    
    func changeLike(indexPath: IndexPath) {
        
    }
    
    func setupNotificationObserver() {
        
    }
}
