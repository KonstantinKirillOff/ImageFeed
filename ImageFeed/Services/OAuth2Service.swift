//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation

enum NetworkErrors: Error {
    case codeError
    case getDataError
}

protocol OAuth2ServiceRouting {
    func fetchAuthToken(by code: String, completion: @escaping  (Result<String, Error>) -> Void)
}

final class OAuth2Service {
    func fetchAuthToken(by code: String, completion: @escaping  (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string: UnsplashTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkErrors.codeError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkErrors.getDataError))
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tokenResponse.accessToken))
                }
                
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
