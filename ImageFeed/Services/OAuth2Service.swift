//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get {
            OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    private init() {}
    
    func fetchAuthToken(by code: String, completion: @escaping  (Result<String, Error>) -> Void) {
        let urlRequest = authTokenRequest(code: code)
        
        let task = object(for: urlRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let object):
                let authToken = object.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.date(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(OAuthTokenResponseBody.self, from: data)
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
extension OAuth2Service {
    private func selfProfileRequest() -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/me")
    }
    
    private func profileImageRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/users/\(username)")
    }
    
    private func photosRequest(page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos?"
        + "page=\(page)"
        + "&&per_page=\(perPage)"
        )
    }
    
    private func likeRequest(photoID: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoID)/like",
                                   httpMethod: "POST")
    }
    
    private func unlikeRequest(photoID: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoID)/like",
                                   httpMethod: "DELETE")
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
    }
}
