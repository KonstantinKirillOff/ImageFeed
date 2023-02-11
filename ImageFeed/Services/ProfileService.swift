//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 11.02.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let authToken = OAuth2TokenStorage.shared.token else { return }
        guard var urlRequest = selfProfileRequest() else { return }

        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = profileResultObject(for: urlRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(var profileObject):
                
                let userName = profileObject.username
                guard let urlRequest = self.profileImageRequest(username: userName) else { return }
                
                let task = self.profileResultObject(for: urlRequest) { result in
                    switch result {
                    case .success(let imageLinks):
                        //profileObject.profileImage = imageLinks.profileImage
                        completion(.success(profileObject))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                task.resume()
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func profileResultObject(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.date(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(ProfileResult.self, from: data)
                    completion(.success(object))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//MARK: requests methods
extension ProfileService {
    private func selfProfileRequest() -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me")
    }
    
    private func profileImageRequest(username: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/users/\(username)")
    }
}
