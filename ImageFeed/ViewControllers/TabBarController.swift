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
		
		//ImageListVC
		let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
		let imageListHelper = ImageListHelper()
		let imageListPresenter = ImageListPresenter(imageListHelper: imageListHelper)
		imagesListViewController.configure(imageListPresenter)
		
		imagesListViewController.tabBarItem = UITabBarItem(
			title: nil,
			image: UIImage(named: "listImage"),
			selectedImage: nil
		)
		
		
		//ProfileVC
		let profileHelper = ProfileViewHelper()
		let profilePresenter = ProfileViewPresenter(profileViewHelper: profileHelper)
		
		let profileViewController = ProfileViewController()
		profileViewController.configure(profilePresenter)
		
		profileViewController.tabBarItem = UITabBarItem(
			title: nil,
			image: UIImage(named: "Profile"),
			selectedImage: nil
		)
		
		viewControllers = [imagesListViewController, profileViewController]
	}
}

