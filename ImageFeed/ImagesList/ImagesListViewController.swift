//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 01.01.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let imagesListService = ImagesListService.shared
    private let placeholder = UIImage(named: "Loader")
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
       return tableView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addSubviews()
        makeConstraints()
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.photos = photos
            }
        guard let token = OAuth2TokenStorage().token else { return }
        imagesListService.fetchPhotosNextPage(token: token)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let imageListCell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell
        else {
            return UITableViewCell()
        }
        
        imageListCell.selectionStyle = .none
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = imagesListService.photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageSize.width
        return imageSize.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageURL = URL(string: imagesListService.photos[indexPath.row].largeImageURL) else { return }
        let viewController = SingleImageViewController()
        viewController.imageURL = imageURL
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let url = URL(string: imagesListService.photos[indexPath.row].thumbImageURL) else { return }
        
        cell.configure(
            isLiked: indexPath.row % 2 == 0,
            date: dateFormatter.string(from: Date()),
            imageURL: url
        )
    }
}
