//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 22.02.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
	override func awakeFromNib() {
		super.awakeFromNib()
		let storyboard = UIStoryboard(name: "Main", bundle: .main)
		
		let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
		imagesListViewController.tabBarItem = UITabBarItem(
			title: nil,
			image: UIImage(named: "listImage"),
			selectedImage: nil
		)
		
		let profileViewController = ProfileViewController()
		profileViewController.tabBarItem = UITabBarItem(
			title: nil,
			image: UIImage(named: "Profile"),
			selectedImage: nil
		)
		
		viewControllers = [imagesListViewController, profileViewController]
	}
}

