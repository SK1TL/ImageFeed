//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 20.01.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIImage()
    }
    
    override func viewDidLayoutSubviews() {
        centerImage()
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController {
    
    func setupUIImage() {
        configureImageView()
        configureScrollView()
    }
    
    func configureImageView() {
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    func configureScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        centerImage()
    }
    
    func centerImage() {
        let visibleRectSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        if contentSize.width < visibleRectSize.width {
            xOffset = (visibleRectSize.width - contentSize.width) * 0.5
        }
        if contentSize.height < visibleRectSize.height {
            yOffset = (visibleRectSize.height - contentSize.height) * 0.5
        }
        scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: 0, right: 0)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
