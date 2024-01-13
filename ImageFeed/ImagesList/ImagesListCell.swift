//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 07.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    private static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    func configure(isLiked: Bool, date: String, image: UIImage) {
        likeButton.setImage(isLiked ? UIImage(named: "Active") : UIImage(named: "No Active"), for: .normal)
        dateLabel.text = date
        cellImage.image = image
    }
}
