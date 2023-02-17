//
//  ProfileImageURL.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 14.02.2023.
//

import Foundation

struct ImageURL: Decodable {
	var profileImage: ProfileImageURL
	
	enum CodingKeys: String, CodingKey {
		case profileImage = "profile_image"
	}
}

struct ProfileImageURL: Decodable {
	let small: String
}
