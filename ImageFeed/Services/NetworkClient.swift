//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation

struct NetworkClient {
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let httpResponse = response as? HTTPURLResponse {
                
                let statusCode = httpResponse.statusCode
                if 200..<300 ~= statusCode {
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkErrors.codeError))
                    return
                }
                
            } else if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.failure(NetworkErrors.getDataError))
            }
        }
        task.resume()
    }
    
    func postRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data,
               let response = response,
               let httpResponse = response as? HTTPURLResponse {
                
                let statusCode = httpResponse.statusCode
                if 200..<300 ~= statusCode {
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkErrors.codeError))
                    return
                }
                
            } else if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.failure(NetworkErrors.getDataError))
            }
        }
        task.resume()
    }
}
