//
//  Profile.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation

struct Profile {
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case bio
        case username
        case email
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
