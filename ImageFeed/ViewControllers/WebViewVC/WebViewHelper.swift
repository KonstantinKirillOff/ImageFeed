//
//  WebViewHelper.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 18.03.2023.
//

import Foundation

fileprivate struct AuthConstants {
	static let responseType = "code"
	static let authPath = "/oauth/authorize"
	static let codePath = "/oauth/authorize/native"
}

protocol WebViewHelperProtocol {
	func authRequest() -> URLRequest?
	func code(from url: URL) -> String?
}

class WebViewHelper {
	let configuration: AuthConfiguration
	
	init(configuration: AuthConfiguration = .standard) {
		self.configuration = configuration
	}
}

extension WebViewHelper: WebViewHelperProtocol {
	func authRequest() -> URLRequest? {
		guard var urlComponents = URLComponents(string: configuration.baseURLString) else { return nil }
		urlComponents.path = AuthConstants.authPath
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: configuration.accessKey),
			URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
			URLQueryItem(name: "response_type", value: AuthConstants.responseType),
			URLQueryItem(name: "scope", value: configuration.accessScope),
		]
		if let url = urlComponents.url {
			return URLRequest(url: url)
		}
		return nil
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
}
