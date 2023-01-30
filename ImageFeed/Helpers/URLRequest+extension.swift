//
//  URLRequest+extension.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 30.01.2023.
//

import Foundation

fileprivate let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        urlRequest.httpMethod = httpMethod
        return urlRequest
    }
}
