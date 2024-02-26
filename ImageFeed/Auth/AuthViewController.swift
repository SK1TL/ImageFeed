//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 06.02.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var entreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypWhite
        button.setTitleColor(.ypBlack, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var unsplashLogo: UIImageView = {
        let unsplashImage = UIImageView()
        unsplashImage.image = UIImage(named: "Logo_of_Unsplash")
        unsplashImage.translatesAutoresizingMaskIntoConstraints = false
        return unsplashImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        addSubviews()
        makeConstraints()
        entreButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
        
    private func addSubviews() {
        view.addSubview(unsplashLogo)
        view.addSubview(entreButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            entreButton.heightAnchor.constraint(equalToConstant: 48),
            entreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            entreButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            entreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            
            unsplashLogo.heightAnchor.constraint(equalToConstant: 60),
            unsplashLogo.widthAnchor.constraint(equalToConstant: 60),
            unsplashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsplashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapLoginButton() {
        let webViewVC = WebViewViewController()
        webViewVC.delegate = self
        navigationController?.pushViewController(webViewVC, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
