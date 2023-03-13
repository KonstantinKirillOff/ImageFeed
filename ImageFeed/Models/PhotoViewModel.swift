//
//  Photo.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 26.02.2023.
//

import Foundation

struct Photo {
	let id: String
	let size: CGSize
	let createAt: Date?
	let welcomeDescription: String
	let thumbImageURL: String
	let largeImageURL: String
	let isLiked: Bool
}
