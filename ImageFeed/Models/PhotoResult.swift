//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 26.02.2023.
//

import Foundation

struct PhotoResult: Decodable {
	let id: String
	let width: Int
	let height: Int
	let isLiked: Bool
	var createdAt: String?
	var description: String?
	var urls: UrlsResult
	
	enum CodingKeys: String, CodingKey {
		case id, width, height, urls
		case createdAt = "created_at"
		case isLiked = "liked_by_user"
	}
}

struct UrlsResult: Decodable {
	let full: String
	let thumb: String
}
