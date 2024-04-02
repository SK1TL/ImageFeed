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
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychainWrapper.string(forKey: key)
        }
        set {
            guard let newValue else { return }
            keychainWrapper.set(newValue, forKey: key)
        }
    }
    
    private init() {}
    
    func removeToken() -> Bool {
        keychainWrapper.removeObject(forKey: key)
    }
}
