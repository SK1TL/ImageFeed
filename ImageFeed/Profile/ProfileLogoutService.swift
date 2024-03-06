//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 06.03.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
   static let shared = ProfileLogoutService()
    
   private init() { }

   func logout() {
      cleanCookies()
   }

   private func cleanCookies() {
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
}
    
