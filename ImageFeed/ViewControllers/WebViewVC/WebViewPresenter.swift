//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 16.03.2023.
//

import Foundation

public protocol IWebViewPresenterProtocol {
	var view: IWebViewControllerProtocol? { get set }
	func viewDidLoad()
	func didUpdateProgressValue(_ newValue: Double)
	func code(from url: URL) -> String?
}

final class WebViewPresenter: IWebViewPresenterProtocol {
	weak var view: IWebViewControllerProtocol?
	var webViewHelper: WebViewHelperProtocol
	
	init(webViewHelper: WebViewHelperProtocol) {
		self.webViewHelper = webViewHelper
	}
	
	func viewDidLoad() {
		guard let urlRequest = webViewHelper.authRequest() else {
			assertionFailure("Bad auth request!")
			return
		}
		
		didUpdateProgressValue(0)
		view?.load(urlRequest: urlRequest)
	}
	
	func didUpdateProgressValue(_ newValue: Double) {
		let newProgressValue = Float(newValue)
		view?.setProgressValue(newProgressValue)
		
		let shouldHideProgress = shouldHideProgress(for: newProgressValue)
		view?.setProgressHidden(shouldHideProgress)
	}
	
	func code(from url: URL) -> String? {
		webViewHelper.code(from: url)
	}
	
	private func shouldHideProgress(for value: Float) -> Bool {
		abs(value - 1.0) <= 0.0001
	}
}
