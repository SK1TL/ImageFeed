//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 10.02.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private var alertPresenter: AlertPresenterProtocol?
    private let profileService = ProfileService.shared
    
    private lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "splash_screen_logo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(viewController: self)
        view.backgroundColor = .ypBackground
        
        addSubviews()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token {
            fetchProfile(token)
        } else {
            let authVC = AuthViewController()
            authVC.delegate = self
            let navigationController = UINavigationController(rootViewController: authVC)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    
    private func addSubviews() {
        view.addSubview(logoView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = TabBarController()
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(token):
                self.fetchProfile(token)
            case .failure:
                self.showAlert(parameter: code, .tokenProblem)
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(profile):
                UIBlockingProgressHUD.dismiss()
                ProfileImageService.shared.fetchProfileImageURL(username: profile.userName) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showAlert(parameter: token, .profileProblem)
            }
        }
    }
    
    private func showAlert(parameter: String, _ problem: ProblemType) {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            error: problem
        ) { [weak self] problem in
            guard let self else { return }
            switch problem {
            case .tokenProblem:
                self.fetchOAuthToken(parameter)
            case .profileProblem:
                self.fetchProfile(parameter)
            case .none:
                break
            }
        }
        alertPresenter?.showAlert(model: alertModel)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code)
    }
}
