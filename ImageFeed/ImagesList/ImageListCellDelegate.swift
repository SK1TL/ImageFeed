//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 04.03.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLiked(_ cell: ImagesListCell)
}
