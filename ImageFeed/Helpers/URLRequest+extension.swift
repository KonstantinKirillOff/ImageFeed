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
        guard var urlComponents = URLComponents(string: baseURLString) else { return nil }
        urlComponents.path = path
        if let url = urlComponents.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            return urlRequest
        }
        return nil
    }
}
