//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 11.02.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    //var profileImage: ProfileImage?
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}
