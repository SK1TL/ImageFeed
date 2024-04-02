//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Артур Гайфуллин on 22.03.2024.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var viewDidLoadRequest = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        viewDidLoadRequest = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
}
