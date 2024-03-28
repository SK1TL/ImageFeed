//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 01.01.2024.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: UIViewController {
    var presenter: ImagesListPresenterProtocol? { get set }
    func setCellIsLiked(by indexPath: IndexPath, isLiked: Bool)
    func presentAlert(model: AlertModel)
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showHUD()
    func dismissHUD()
}

final class ImagesListViewController: UIViewController {
    
    var presenter: ImagesListPresenterProtocol?
    
    private var alertPresenter: AlertPresenterProtocol?
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
        presenter?.setupNotificationObserver()
        setupImageListService()
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
        presenter?.updateTableViewAnimated()
        presenter?.fetchPhotosNextPage()
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func showHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissHUD() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func presentAlert(model: AlertModel) {
        alertPresenter?.showAlert(model: model)
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexes = (oldCount..<newCount).map {
                    IndexPath(row: $0, section: 0)
                }
                tableView.insertRows(at: indexes, with: .automatic)
            }
        }
    }
    
    func setCellIsLiked(by indexPath: IndexPath, isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        cell.setIsLiked(isLiked)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photos.count ?? .zero
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
        let imageSize = presenter?.photos[indexPath.row].size ?? .zero
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageSize.width
        return imageSize.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let largeImageURL = presenter?.photos[indexPath.row].largeImageURL,
            let imageURL = URL(string: largeImageURL)
        else { return }
        let viewController = SingleImageViewController()
        viewController.imageURL = imageURL
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard
            let photo = presenter?.photos[indexPath.row],
            let url = URL(string: photo.thumbImageURL)
        else { return }
        
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
        showHUD()
        presenter?.changeLike(indexPath: indexPath)
    }
}
