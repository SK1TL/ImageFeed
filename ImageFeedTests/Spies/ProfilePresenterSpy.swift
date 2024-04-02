//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Артур Гайфуллин on 25.03.2024.
//

import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDidloadCalled = false
    
    func updateAvatar() {}
    
    func logout() {}
    
    func viewDidLoad() {
        viewDidloadCalled = true
    }
}
