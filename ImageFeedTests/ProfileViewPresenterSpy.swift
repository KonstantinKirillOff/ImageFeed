//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 22.03.2023.
//

import UIKit
@testable import ImageFeed

final class ProfileViewPresenterSpy: IProfileViewPresenterProtocol {
	var view: ImageFeed.IProfileViewControllerProtocol?
	let helper: IProfileViewHelperProtocol?
	
	init(helper: IProfileViewHelperProtocol) {
		self.helper = helper
	}
	
	func logOut() {
		helper?.cleanCookie()
		helper?.cleanStorage()
	}
	
	func getImage(for imageView: UIImageView, imageURL: URL) {
		imageView.image = UIImage(systemName: "person.crop.circle.fill")
	}
}
