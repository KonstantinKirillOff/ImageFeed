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
	func getImage(for imageView: UIImageView)
}

final class ProfileViewPresenter: IProfileViewPresenterProtocol {
	weak var view: IProfileViewControllerProtocol?
	var profileViewHelper: IProfileViewHelperProtocol
	
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
	
	func getImage(for imageView: UIImageView) {
		guard let profileImageURL = ProfileImageService.shared.avatarURL,
			  let imageURL = URL(string: profileImageURL)
		else { return }
		
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(with: imageURL) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let value):
				self.view?.updateAvatar(avatarImage: value.image)
			case .failure(_):
				self.view?.updateAvatar(avatarImage: UIImage(systemName: "person.crop.circle")!)
			}
		}
	}
}

