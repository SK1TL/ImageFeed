//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 23.03.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateAvatar()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var logoutHelper: LogoutHelperProtocol
    
    init(logoutHelper: LogoutHelperProtocol) {
        self.logoutHelper = logoutHelper
        setupObserver()
    }
    
    func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.updateAvatar(url: url)
    }
    
    func logout() {
        logoutHelper.logout()
    }
}
