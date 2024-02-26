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
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewContoller = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        viewControllers = [imageListViewContoller, profileViewController]
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
