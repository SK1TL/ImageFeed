//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 10.02.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private var blokingProgressHUD = UIBlockingProgressHUD()
    private let profileService = ProfileService.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    private lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "splash_screen_logo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor(named: "YP Background")
        if OAuth2TokenStorage().token != nil {
            switchToTabBarController()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let viewController = storyboard.instantiateViewController(
                withIdentifier: "AuthViewController"
            ) as! AuthViewController
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
        
        addSubviews()
        makeConstraints()
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
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token)
                UIBlockingProgressHUD.show()
            case .failure(let error):
                UIBlockingProgressHUD.show()
                print("Token not received \(error)")
                self.showAlert(parameter: code, .tokenProblem)
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.userName) { _ in}
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Profile not received \(error)")
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
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
}

