//
//  URLRequest+extension.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 30.01.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(path: String,
                                httpMethod: String = "GET",
                                baseURLString: String = Constants.defaultApiBaseURLString) -> URLRequest? {
        guard let url = URL(string: baseURLString) else { return nil }
        guard let baseUrl = URL(string: path, relativeTo: url) else { return nil }
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = httpMethod
        
        if baseURLString == Constants.defaultApiBaseURLString {
            guard let authToken = OAuth2TokenStorage.shared.token else { return nil }
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
