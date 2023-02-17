//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 11.02.2023.
//

import Foundation

//struct ProfileUserName: Decodable {
//    let username: String
//}

struct ProfileResult: Decodable {
    let userName: String
    let firstName: String
    let lastName: String
    var bio: String?
   // var profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        //case profileImage = "profile_image"
        case bio
    }
}

//struct ProfileImage: Decodable {
//    let small: String
//}
