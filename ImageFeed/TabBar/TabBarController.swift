//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 21.02.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypWhiteAlpha50
        
        let imageListViewContoller = ImagesListViewController()
        imageListViewContoller.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_no_active"),
            selectedImage: UIImage(named: "tab_editorial_active")
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_no_active"),
            selectedImage: UIImage(named: "tab_profile_active")
        )
        
        selectedIndex = 0
        viewControllers = [imageListViewContoller, profileViewController]
    }
}
