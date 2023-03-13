//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 14.02.2023.
//

import Foundation

final class ProfileImageService {
	static let shared = ProfileImageService()
	static let DidChangeNotification = Notification.Name(NotificationConstants.profileImageProviderDidChange)
	
	private let networkClient = NetworkClient.shared
	private (set) var avatarURL: String?
	
	private init() {}
	
	func fetchProfileImageURL(_ userName: String, completion: @escaping (Result<String, Error>) -> Void) {
		guard let urlRequestProfileData = profileImageRequest(username: userName) else { return }
		
		let task = networkClient.getObject(dataType: ImageURL.self, for: urlRequestProfileData) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let profileResult):
				let urlImage = profileResult.profileImage.medium
				self.avatarURL = urlImage
				completion(.success(urlImage))
				
				NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification,
												object: self,
												userInfo: ["URL": urlImage])
			case .failure(let error):
				completion(.failure(error))
			}
		}
		task.resume()
	}
}

extension ProfileImageService {
	private func profileImageRequest(username: String) -> URLRequest? {
		URLRequest.makeHTTPRequest(path: "/users/\(username)")
	}
}
