//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 19.03.2023.
//

import UIKit
import Kingfisher

public protocol IProfileViewPresenterProtocol {
	var view: IProfileViewControllerProtocol? { get set }
	
	func logOut()
	func getImage(for imageView: UIImageView, imageURL: URL)
}

final class ProfileViewPresenter: IProfileViewPresenterProtocol {
	weak var view: IProfileViewControllerProtocol?
	var profileViewHelper: IProfileViewHelperProtocol
	
	private let profileService = ProfileService.shared
	
	init(profileViewHelper: IProfileViewHelperProtocol) {
		self.profileViewHelper = profileViewHelper
	}
	
	func logOut() {
		profileViewHelper.cleanCookie()
		profileViewHelper.cleanStorage()
		
		guard let window = UIApplication.shared.windows.first else {
			assertionFailure("Invalid configuration")
			return
		}
		let splashVC = SplashViewController()
		window.rootViewController = splashVC
	}
	
	func getImage(for imageView: UIImageView, imageURL: URL) {
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "person.crop.circle")!)
	}
}

