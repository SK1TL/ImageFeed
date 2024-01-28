//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 19.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var avatarImageView: UIImageView!
    
    @IBAction private func didTapLogoutButton() {
    }
}
