//
//  User.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 11.02.2023.
//

import Foundation

struct User {
    let username: String
    let profileImage: URL
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "profile_image"
    }
}
