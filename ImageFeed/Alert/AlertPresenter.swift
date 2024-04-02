//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 20.02.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
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
            model.completion?(model.error)
        }
        
        alert.addAction(alertAction)
        
        viewController?.present(alert, animated: true)
    }
}
