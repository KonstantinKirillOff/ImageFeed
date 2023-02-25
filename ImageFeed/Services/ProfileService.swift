//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 11.02.2023.
//

import UIKit

final class ProfileService {
    static let shared = ProfileService()
	private let networkClient = NetworkClient.shared
    private(set) var profile: Profile?
    
    private init() {}
	
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let urlRequestSelfProfile = selfProfileRequest() else { return }
		let task = networkClient.getObject(dataType: ProfileResult.self, for: urlRequestSelfProfile) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
				let newProfile = self.convertToProfile(from: profileResult)
				self.profile = newProfile
				completion(.success(profileResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func convertToProfile(from profileResult: ProfileResult, image: UIImage = UIImage()) -> Profile? {
        return Profile(username: profileResult.userName,
                       firstName: profileResult.firstName,
                       lastName: profileResult.lastName,
                       bio: profileResult.bio ?? "")
    }
}

//MARK: requests methods
extension ProfileService {
    private func selfProfileRequest() -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me")
    }
}
