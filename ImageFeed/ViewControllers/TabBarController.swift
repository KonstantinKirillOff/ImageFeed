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
		
		let profileHelper = ProfileViewHelper()
		let profilePresenter = ProfileViewPresenter(profileViewHelper: profileHelper)
		
		let profileViewController = ProfileViewController()
		profileViewController.presenter = profilePresenter
		profilePresenter.view = profileViewController
		
		profileViewController.tabBarItem = UITabBarItem(
			title: nil,
			image: UIImage(named: "Profile"),
			selectedImage: nil
		)
		
		viewControllers = [imagesListViewController, profileViewController]
	}
}

