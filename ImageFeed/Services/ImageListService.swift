//
//  ImageListServices.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 26.02.2023.
//

import Foundation

final class ImageListService {
	static let shared = ImageListService()
	static let imageListDidChangeNotification = Notification.Name(NotificationConstants.imageListDidChange)
	
	private let networkClient = NetworkClient.shared
	private (set) var photos: [Photo] = []
	private var lastLoadPage: Int?
	private var currentTask: URLSessionTask?
	
	lazy var dateFormatter: ISO8601DateFormatter = {
		let dateFormatter = ISO8601DateFormatter()
		return dateFormatter
	}()
	
	func fetchPhotosNextPage()  {
		if currentTask != nil {
			return
		}
		
		let nextPage  = lastLoadPage == nil ? 1 : lastLoadPage! + 1
		
		guard let urlRequest = photosRequest(page: nextPage, perPage: Constants.photosPerPage) else {
			assertionFailure("Bad photos request")
			return
		}
		
		let task = networkClient.getObject(dataType: [PhotoResult].self, for: urlRequest) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let photoResult):
				self.addNewPhotos(from: photoResult)
			case .failure(let error):
				print(error.localizedDescription)
			}
			self.currentTask = nil
			self.lastLoadPage = nextPage
		}
		currentTask = task
		task.resume()
	}
	
	private func addNewPhotos(from result: [PhotoResult]) {
		result.forEach { photoResult in
			let photoViewModel = convertToPhotoViewModel(from: photoResult)
			photos.append(photoViewModel)
		}
		NotificationCenter.default.post(name: ImageListService.imageListDidChangeNotification,
										object: self,
										userInfo: ["Photos": self.photos])
	}
	
	private func convertToPhotoViewModel(from photoResult: PhotoResult) -> Photo {
		return Photo(id: photoResult.id,
					 size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
					 createAt: photoResult.createdAt != nil ? dateFormatter.date(from: photoResult.createdAt!) : nil,
					 welcomeDescription: photoResult.description ?? "",
					 thumbImageURL: photoResult.urls.thumb,
					 largeImageURL: photoResult.urls.full,
					 isLiked: photoResult.isLiked)
	}
	
	func changeLike(photoID: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
		guard let urlRequest = isLike ? likeRequest(photoID: photoID) : unlikeRequest(photoID: photoID) else {
			assertionFailure("Bad photos request")
			return
		}
		
		let fulfillCompletion: (Result<Void, Error>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		
		let task = URLSession.shared.dataTask(with: urlRequest) { _ , response, error in
			if let response = response,
			   let statusCode = (response as? HTTPURLResponse)?.statusCode {
				
				if 200..<300 ~= statusCode {
					fulfillCompletion(.success(()))
				} else {
					fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
				}
			} else if let error = error {
				fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
			} else {
				fulfillCompletion(.failure(NetworkError.urlSessionError))
			}
		}
		task.resume()
	}
	
	private init() {}
}

//MARK: requests methods
extension ImageListService {
	private func photosRequest(page: Int, perPage: Int) -> URLRequest? {
		URLRequest.makeHTTPRequest(path: "/photos?"
								   + "page=\(page)"
								   + "&&per_page=\(perPage)")
	}
	
	private func likeRequest(photoID: String) -> URLRequest? {
		URLRequest.makeHTTPRequest(path: "/photos/\(photoID)/like",
								   httpMethod: "POST")
	}
	
	private func unlikeRequest(photoID: String) -> URLRequest? {
		URLRequest.makeHTTPRequest(path: "/photos/\(photoID)/like",
								   httpMethod: "DELETE")
	}
}
