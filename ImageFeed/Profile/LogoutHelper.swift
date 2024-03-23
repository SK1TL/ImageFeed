//
//  LogoutHelper.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 23.03.2024.
//

import Foundation
import WebKit

protocol LogoutHelperProtocol {
    func logout()
}

final class LogoutHelper: LogoutHelperProtocol {
    
    func logout() {
        resetToken()
        resetPhotos()
        resetCookies()
        switchToSplashViewController()
    }
    
    func resetToken() {
        guard OAuth2TokenStorage.shared.removeToken() else {
            assertionFailure("Cannot remove token")
            return
        }
    }
    
    func resetPhotos() {
        ImagesListService.shared.resetPhotos()
    }
    
    func resetCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
}
