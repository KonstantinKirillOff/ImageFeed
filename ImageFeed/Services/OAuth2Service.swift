//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation

final class OAuth2Service {
	static let shared = OAuth2Service()
	private let tokenStorage = OAuth2TokenStorage.shared
	private let networkClient = NetworkClient.shared
	
	private var currentTask: URLSessionTask?
	private var lastCode: String?
	
	private (set) var authToken: String? {
		get {
			tokenStorage.token
		}
		set {
			tokenStorage.token = newValue
		}
	}
	
	private init() {}
	
	func fetchAuthToken(by code: String, completion: @escaping  (Result<String, Error>) -> Void) {
		assert(Thread.isMainThread, "Bad thread before fetch token!")
		if currentTask != nil {
			if lastCode != code {
				currentTask?.cancel()
			} else {
				return
			}
		} else {
			if lastCode == code {
				return
			}
		}
		
		lastCode = code
		guard let urlRequest = authTokenRequest(code: code) else {
			fatalError("Bad auth token request")
		}
		
		let task = networkClient.getObject(dataType: OAuthTokenResponseBody.self, for: urlRequest) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let object):
				let authToken = object.accessToken
				self.authToken = authToken
				completion(.success(authToken))
			case .failure(let error):
				completion(.failure(error))
				self.lastCode = nil
			}
			self.currentTask = nil
		}
		currentTask = task
		task.resume()
	}
}

//MARK: requests methods
extension OAuth2Service {
	private func authTokenRequest(code: String) -> URLRequest? {
		URLRequest.makeHTTPRequest(
			path: "\(Constants.baseAuthTokenPath)"
			+ "?client_id=\(Constants.accessKey)"
			+ "&&client_secret=\(Constants.secretKey)"
			+ "&&redirect_uri=\(Constants.redirectURI)"
			+ "&&code=\(code)"
			+ "&&grant_type=authorization_code",
			httpMethod: "POST",
			baseURLString: Constants.baseURLString
		)
	}
}
