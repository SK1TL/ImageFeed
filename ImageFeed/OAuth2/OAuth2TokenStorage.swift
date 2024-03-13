//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 08.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private let key = "token"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: key)
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: key)
        }
    }
    
    private init() {}
    
    func removeToken() -> Bool {
        KeychainWrapper.standard.removeObject(forKey: key)
    }
}
