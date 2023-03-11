//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 26.01.2023.
//

import UIKit

final class AuthViewController: UIViewController {
	private let showWebViewSegueIdentifier = "ShowWebView"
	weak var delegate: IAuthViewControllerDelegate!
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == showWebViewSegueIdentifier {
			guard let webViewVC = segue.destination as? WebViewViewController else { return }
			webViewVC.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
}

extension AuthViewController: IWebViewViewControllerDelegate {
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWith code: String) {
		vc.dismiss(animated: true) { [weak self] in
			guard let self = self else { return }
			self.delegate.authViewController(self, didAuthenticateWithCode: code)
		}
	}
	
	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		vc.dismiss(animated: true)
	}
}
