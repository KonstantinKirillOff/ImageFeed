//
//  URLRequest+extension.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 30.01.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String = "GET", baseURL: URL = DefaultApiBaseURL) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        urlRequest.httpMethod = httpMethod
        return urlRequest
    }
}
