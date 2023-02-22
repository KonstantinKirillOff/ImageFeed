//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 11.02.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let userName: String
    let firstName: String
    let lastName: String
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
