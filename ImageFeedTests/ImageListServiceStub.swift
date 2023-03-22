//
//  ImageListServiceStub.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 22.03.2023.
//

import Foundation
import CoreGraphics
@testable import ImageFeed

final class ImageListServiceStub: IImageListServiceProtocol {
	static let imageListDidChangeNotification = Notification.Name(NotificationConstants.imageListDidChange)
	var photos: [ImageFeed.Photo] = []
	
	func fetchPhotosNextPage() {
		photos = [
			ImageFeed.Photo(id: "1", size: CGSize(width: 20, height: 20), createAt: nil, welcomeDescription: "welcom1", thumbImageURL: "", largeImageURL: "", isLiked: false),
			ImageFeed.Photo(id: "2", size: CGSize(width: 20, height: 20), createAt: nil, welcomeDescription: "welcom2", thumbImageURL: "", largeImageURL: "", isLiked: false),
			ImageFeed.Photo(id: "3", size: CGSize(width: 20, height: 20), createAt: nil, welcomeDescription: "welcom3", thumbImageURL: "", largeImageURL: "", isLiked: false)
		]
		
		NotificationCenter.default.post(name: ImageListService.imageListDidChangeNotification,
										object: self,
										userInfo: ["Photos": self.photos])
	}
	
	func changeLike(photoID: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
		
	}
}
