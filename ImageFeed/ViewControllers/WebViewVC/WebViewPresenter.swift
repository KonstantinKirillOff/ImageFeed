//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 16.03.2023.
//

import Foundation

fileprivate struct AuthConstants {
	static let responseType = "code"
	static let authPath = "/oauth/authorize"
	static let codePath = "/oauth/authorize/native"
}

public protocol IWebViewPresenterProtocol {
	var view: IWebViewControllerProtocol? { get set }
	func viewDidLoad()
	func didUpdateProgressValue(_ newValue: Double)
	func code(from url: URL) -> String?
}

final class WebViewPresenter: IWebViewPresenterProtocol {
	weak var view: IWebViewControllerProtocol?
	
	func viewDidLoad() {
		guard let urlRequest = authRequest() else {
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
		if let urlComponents = URLComponents(string: url.absoluteString),
		   urlComponents.path == AuthConstants.codePath,
		   let items = urlComponents.queryItems,
		   let codeItems = items.first(where: { $0.name == AuthConstants.responseType }) {
			return codeItems.value
		} else {
			return nil
		}
	}
	
	private func authRequest() -> URLRequest? {
		guard var urlComponents = URLComponents(string: Constants.baseURLString) else { return nil }
		urlComponents.path = AuthConstants.authPath
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.accessKey),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
			URLQueryItem(name: "response_type", value: AuthConstants.responseType),
			URLQueryItem(name: "scope", value: Constants.accessScope),
		]
		if let url = urlComponents.url {
			return URLRequest(url: url)
		}
		return nil
	}
	
	private func shouldHideProgress(for value: Float) -> Bool {
		abs(value - 1.0) <= 0.0001
	}
}
