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
        guard let urlRequestSelfProfile = selfProfileRequest() else { return }
        let task = getObject(dataType: ProfileUserName.self, for: urlRequestSelfProfile) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileUserName):
                let userName = profileUserName.username
                print(userName)
                guard let urlRequestProfileData = self.profileImageRequest(username: userName) else { return }

                let task = self.getObject(dataType: ProfileResult.self, for: urlRequestProfileData) { result in
                    switch result {
                    case .success(let profileResult):
                        completion(.success(profileResult))
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
    
    func fetchImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let urlRequest = URLRequest(url: url)
        let task = urlSession.date(for: urlRequest) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func getObject<T: Decodable>(dataType: T.Type, for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.date(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(T.self, from: data)
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
