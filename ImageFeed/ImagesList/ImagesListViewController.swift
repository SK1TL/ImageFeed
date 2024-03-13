//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 01.01.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private var alertPresenter: AlertPresenterProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private let tokenStorage = OAuth2TokenStorage.shared
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
        setupNotificationObserver()
        setupImageListService()
    }
    
    private func fetchPhotosNextPage() {
        guard let token = OAuth2TokenStorage.shared.token else { return }
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
    
    private func setupImageListService() {
        updateTableViewAnimated()
        fetchPhotosNextPage()
    }
    
    private func setupNotificationObserver() {
      imagesListServiceObserver = NotificationCenter.default
        .addObserver(
          forName: ImagesListService.didChangeNotification,
          object: nil,
          queue: .main
        ) { [weak self] _ in
          self?.updateTableViewAnimated()
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexes = (oldCount..<newCount).map {
                    IndexPath(row: $0, section: 0)
                }
                tableView.insertRows(at: indexes, with: .automatic)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
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
        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageSize.width
        return imageSize.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageURL = URL(string: photos[indexPath.row].largeImageURL) else { return }
        let viewController = SingleImageViewController()
        viewController.imageURL = imageURL
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.thumbImageURL) else { return }
        
        var dateString: String? = nil
        
        if let createdAt = photo.createdAt {
            dateString = dateFormatter.string(from: createdAt)
        }
        
        cell.configure(
            isLiked: photo.isLiked,
            date: dateString,
            imageURL: url
        )
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLiked(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        guard let token = OAuth2TokenStorage.shared.token else { return }
        imagesListService.changeLike(
            token,
            photoId: photo.id,
            isLike: photo.isLiked
        ) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            guard let self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    cell.setIsLiked(!photo.isLiked)
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        let oldPhoto = photo
                        let newPhoto = Photo(
                            id: oldPhoto.id,
                            size: oldPhoto.size,
                            createdAt: oldPhoto.createdAt,
                            welcomeDescription: oldPhoto.welcomeDescription,
                            thumbImageURL: oldPhoto.thumbImageURL,
                            largeImageURL: oldPhoto.largeImageURL,
                            isLiked: !oldPhoto.isLiked
                        )
                        self.photos.remove(at: index)
                        self.photos.insert(newPhoto, at: index)
                    }
                }
            case .failure:
                presentLikeAlert()
            }
        }
    }
    
    private func presentLikeAlert() {
        let alertModel = AlertModel(
            title: "Like error⚠️",
            message: "Не удалось поставить лайк😢",
            buttonText: "Try again!",
            error: nil
        ) { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }
        alertPresenter?.showAlert(model: alertModel)
    }
}
