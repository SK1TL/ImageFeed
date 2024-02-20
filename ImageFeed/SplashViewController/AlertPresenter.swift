//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 20.02.2024.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var splashViewController: SplashViewController?
    
    init(splashViewController: SplashViewController? = nil) {
        self.splashViewController = splashViewController
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: model.buttonText,
            style: .default
        ) { _ in
            model.completion(model.error)
        }
    }
}

