//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 06.02.2024.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    private lazy var authWebView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let loadingView = UIProgressView()
        loadingView.progressViewStyle = .default
        loadingView.progressTintColor = .ypBlack
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBackground
        
        setupNavigationBar()
        addSubviews()
        makeConstraints()
        
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString.rawValue) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI.rawValue),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope.rawValue)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        authWebView.load(request)
        
        estimatedProgressObservation = authWebView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.updateProgress()
             }
        )
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .ypBlack
        let backImage = UIImage(named: "nav_back_button")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
    }
    
    private func addSubviews() {
        view.addSubview(authWebView)
        view.addSubview(progressView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            authWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authWebView.topAnchor.constraint(equalTo: view.topAnchor),
            authWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func updateProgress() {
        progressView.progress = Float(authWebView.estimatedProgress)
        progressView.isHidden = fabs(authWebView.estimatedProgress - 1.0) <= 0.0001
    }
    
    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
