//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 08.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let key = "Auth token"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: key)
        }
        set {
            KeychainWrapper.standard.set(newValue!, forKey: key)
        }
    }
}
