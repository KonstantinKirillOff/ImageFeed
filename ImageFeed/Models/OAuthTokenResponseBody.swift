//
//  AccessRequest.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case scope
        case accessToken = "access_token"
        case tokenType = "token_type"
        case createdAt = "created_at"
    }
}
