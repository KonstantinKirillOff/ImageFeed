//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let userDefault = UserDefaults.standard
    
    var token: String? {
        get {
            userDefault.string(forKey: "bearerToken")
        }
        set {
            userDefault.set(newValue, forKey: "bearerToken")
        }
    }
    
    private init() {}
}
