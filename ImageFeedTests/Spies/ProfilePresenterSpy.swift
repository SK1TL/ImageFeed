//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Артур Гайфуллин on 25.03.2024.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidloadCalled: Bool = false
    
    func updateAvatar() {   }
    
    func logout() {   }
    
    func viewDidLoad() {
        viewDidloadCalled = true
    }
}
