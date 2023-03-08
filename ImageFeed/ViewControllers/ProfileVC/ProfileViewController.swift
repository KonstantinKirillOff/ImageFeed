//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 08.01.2023.
//

import UIKit
import ProgressHUD
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
	private let profileService = ProfileService.shared
	private var profileImageServiceObserver: NSObjectProtocol?
	
	
	private lazy var userPickImage: UIImageView = {
		if let userImage = UIImage(named: "UserPick") {
			return configImage(image: userImage)
		}
		return UIImageView()
	}()
	
	private lazy var escapeButton: UIButton = {
		if let exitImage = UIImage(named: "Exit") {
			let button = UIButton.systemButton(with: exitImage, target: self, action: #selector(exitButtonTapped))
			button.tintColor = UIColor.ypRed
			button.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(button)
			return button
		}
		return UIButton()
	}()
	
	private lazy var userName: UILabel = {
		let label = configLabel(text: "Екатерина Новикова")
		label.textColor = UIColor.ypWhite
		label.font = .systemFont(ofSize: 23, weight: .bold)
		return label
	}()
	
	private lazy var userLogin: UILabel = {
		let label =  configLabel(text: "@ekaterina_nov")
		label.textColor = UIColor.ypGrey
		label.font = .systemFont(ofSize: 13, weight: .regular)
		return label
	}()
	
	private lazy var userMessage: UILabel = {
		let label =  configLabel(text: "Hello, world!")
		label.textColor = UIColor.ypWhite
		label.font = .systemFont(ofSize: 13, weight: .regular)
		return label
	}()

	override var preferredStatusBarStyle: UIStatusBarStyle {
		.lightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.ypBlack
		
		setConstraints()
		
		profileImageServiceObserver = NotificationCenter.default
			.addObserver(forName: ProfileImageService.DidChangeNotification,
						 object: nil,
						 queue: .main,
						 using: { [weak self] _ in
				
				guard let self = self else { return }
				self.updateAvatar()
			})
		if let profile = profileService.profile {
			updateProfileDetails(profile: profile)
		}
		updateAvatar()
	}

	override func viewDidLayoutSubviews() {
		userPickImage.layer.cornerRadius = userPickImage.bounds.width / 2
		userPickImage.clipsToBounds = true
	}

	@objc private func exitButtonTapped() {
		cleanCookie()
		cleanStorage()
		
		guard let window = UIApplication.shared.windows.first else {
			fatalError("Invalid configuration")
		}
		let splashVC = SplashViewController()
		window.rootViewController = splashVC
	}
	
	private func updateAvatar() {
		guard let profileImageURL = ProfileImageService.shared.avatarURL,
			  let imageURL = URL(string: profileImageURL)
		else { return }
		
		userPickImage.kf.indicatorType = .activity
		userPickImage.kf.setImage(with: imageURL,
								  placeholder: UIImage(systemName: "person.crop.circle"))
	}
	
	private func updateProfileDetails(profile: Profile) {
		userName.text = profile.name
		userLogin.text = profile.loginName
		userMessage.text = profile.bio
	}

	private func configLabel(text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		return label
	}
	
	private func configImage(image: UIImage) -> UIImageView {
		let imageElement = UIImageView(image: image)
		imageElement.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imageElement)
		return imageElement
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			userPickImage.heightAnchor.constraint(equalToConstant: 70),
			userPickImage.widthAnchor.constraint(equalToConstant: 70),
			userPickImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
			userPickImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			
			escapeButton.heightAnchor.constraint(equalToConstant: 24),
			escapeButton.widthAnchor.constraint(equalToConstant: 24),
			escapeButton.centerYAnchor.constraint(equalTo: userPickImage.centerYAnchor),
			escapeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
			
			userName.leadingAnchor.constraint(equalTo: userPickImage.leadingAnchor),
			userName.topAnchor.constraint(equalTo: userPickImage.bottomAnchor, constant: 8),
			
			userLogin.leadingAnchor.constraint(equalTo: userPickImage.leadingAnchor),
			userLogin.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
			
			userMessage.leadingAnchor.constraint(equalTo: userPickImage.leadingAnchor),
			userMessage.topAnchor.constraint(equalTo: userLogin.bottomAnchor, constant: 8)
		])
	}
	
	private func cleanCookie() {
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
			}
		}
	}
	
	private func cleanStorage() {
		OAuth2TokenStorage.shared.removeToken()
	}
	
}
