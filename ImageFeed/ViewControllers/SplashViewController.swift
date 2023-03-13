//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
	private let profileService = ProfileService.shared
	private let profileImageService = ProfileImageService.shared
	
	private let showGalleryFlowIdentifier = "showGalleryFlow"
	private let showAuthFlowIdentifier = "showAuthFlow"
	
	private var authCode: String?
	private var alertPresenter: IAlertPresenterProtocol!
	
	private lazy var logoImage: UIImageView = {
		if let userImage = UIImage(named: "YPicon") {
			let imageElement = UIImageView(image: userImage)
			imageElement.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(imageElement)
			return imageElement
		}
		return UIImageView()
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		alertPresenter = AlertPresenter(delegate: self)
		view.backgroundColor = UIColor.ypBlack
		setConstraints()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let token = OAuth2TokenStorage.shared.token  {
			fetchProfile(for: token)
		} else if authCode == nil {
			let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "authVC")
			guard let authVC = authViewController as? AuthViewController else { return }
			authVC.delegate = self
			authVC.modalPresentationStyle = .fullScreen
			present(authVC , animated: true)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNeedsStatusBarAppearanceUpdate()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		.lightContent
	}
	
	private func switchToTapBarController() {
		guard let window = UIApplication.shared.windows.first else {
			assertionFailure("Invalid configuration")
			return
		}
		let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
		window.rootViewController = tabBarController
	}
	
	private func fetchProfile(for authToken: String) {
		profileService.fetchProfile(authToken) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let profileResult):
				UIBlockingProgressHUD.dismiss()
				self.profileImageService.fetchProfileImageURL(profileResult.userName) { _ in }
				self.switchToTapBarController()
			case .failure(let error):
				self.alertPresenter.preparingDataAndDisplay(alertText: "Не удалось войти в систему. \(error.localizedDescription)") {
					self.performSegue(withIdentifier: self.showAuthFlowIdentifier, sender: nil)
					self.authCode = nil
				}
				UIBlockingProgressHUD.dismiss()
			}
		}
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
		])
	}
}

extension SplashViewController: IAlertPresenterDelegate {
	func showAlert(alert: UIAlertController) {
		self.present(alert, animated: true, completion: nil)
	}
}

extension SplashViewController: IAuthViewControllerDelegate {
	func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
		UIBlockingProgressHUD.show()
		authCode = code
		vc.dismiss(animated: true) { [weak self] in
			guard let self = self else { return }
			OAuth2Service.shared.fetchAuthToken(by: code) { result in
				switch result {
				case .success(let token):
					self.fetchProfile(for: token)
				case .failure(let error):
					self.alertPresenter.preparingDataAndDisplay(alertText: "Не удалось войти в систему. \(error.localizedDescription)") {
						self.performSegue(withIdentifier: self.showAuthFlowIdentifier, sender: nil)
						self.authCode = nil
					}
					UIBlockingProgressHUD.dismiss()
				}
			}
		}
	}
}
