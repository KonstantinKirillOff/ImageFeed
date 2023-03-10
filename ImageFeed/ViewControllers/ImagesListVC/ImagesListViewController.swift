//
//  ViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 27.12.2022.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
	@IBOutlet private var tableView: UITableView!
	private var photos: [Photo] = []
	
	private let showSingleImageSegueIdentifier = "ShowSingleImage"
	private var imageListServiceObserver: NSObjectProtocol?
	private let imageListService = ImageListService.shared
	
	private var alertPresenter: IAlertPresenterProtocol!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		alertPresenter = AlertPresenter(delegate: self)
		
		tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
		
		if photos.count == 0 {
			imageListService.fetchPhotosNextPage()
		}
		imageListServiceObserver = NotificationCenter.default
			.addObserver(forName: ImageListService.imageListDidChangeNotification,
						 object: nil,
						 queue: .main,
						 using: { [weak self] _ in
				
				guard let self = self else { return }
				self.updateTableViewAnimated()
			})
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		.lightContent
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == showSingleImageSegueIdentifier {
			guard let singleImageVC = segue.destination as? SingleImageViewController,
				  let indexPath = sender as? IndexPath else { return }
			
			let photo = photos[indexPath.row]
			singleImageVC.photo = photo
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
	
	private func updateTableViewAnimated() {
		tableView.performBatchUpdates {
			let startIndex = photos.count
			let newCount = imageListService.photos.count
			
			photos = imageListService.photos
			
			var rows = [IndexPath]()
			for n in startIndex..<newCount {
				rows.append(IndexPath(row: n, section: 0))
			}
			tableView.insertRows(at: rows, with: .automatic)
		}
	}
	
	private func reloadRowForTable(indexPath: IndexPath) {
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
	private func replacePhotoWithNewValue(photo: Photo) {
		if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
			let newPhoto = Photo(id: photo.id,
								 size: photo.size,
								 createAt: photo.createAt,
								 welcomeDescription: photo.welcomeDescription,
								 thumbImageURL: photo.thumbImageURL,
								 largeImageURL: photo.largeImageURL,
								 isLiked: !photo.isLiked)
			photos[index] = newPhoto
		}
	}
}

extension ImagesListViewController: IAlertPresenterDelegate {
	func showAlert(alert: UIAlertController) {
		self.present(alert, animated: true, completion: nil)
	}
}

extension ImagesListViewController: ImagesListCellDelegate {
	func imageListCellDidTapLike(_ cell: ImageListCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		let photo = photos[indexPath.row]
		
		UIBlockingProgressHUD.show()
		imageListService.changeLike(photoID: photo.id,
									isLike: !photo.isLiked) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(_):
				self.replacePhotoWithNewValue(photo: photo)
				cell.setIsLiked(isLike: self.photos[indexPath.row].isLiked)
				self.reloadRowForTable(indexPath: indexPath)
				UIBlockingProgressHUD.dismiss()
			case .failure(let error):
				self.alertPresenter.preparingDataAndDisplay(alertText: "???? ?????????????? ???????????????????? like. \(error.localizedDescription)") {
					UIBlockingProgressHUD.dismiss()
				}
			}
		}
		reloadRowForTable(indexPath: indexPath)
	}
}

extension ImagesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		photos.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reusableIdentifier, for: indexPath)
		
		guard let imageListCell = cell as? ImageListCell else {
			return UITableViewCell()
		}
		
		let photo = photos[indexPath.row]
		
		imageListCell.reloadRowFunction = { [weak self] in
			guard let self = self else { return }
			self.reloadRowForTable(indexPath: indexPath)
		}
		imageListCell.delegate = self
		imageListCell.configCell(photo: photo)
		
		return imageListCell
	}
}

extension ImagesListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let photo = photos[indexPath.row]
		
		let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		let imageWidth = photo.size.width
		let scale = imageViewWidth / imageWidth
		let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
		return cellHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row + 1 == photos.count {
			imageListService.fetchPhotosNextPage()
		}
	}
}

