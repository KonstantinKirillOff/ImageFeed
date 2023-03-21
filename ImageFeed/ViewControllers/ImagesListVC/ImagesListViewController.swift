//
//  ViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 27.12.2022.
//

import UIKit
import Kingfisher

protocol IImageListViewControllerProtocol {
	func updateTableViewAnimated(startIndex: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController, IImageListViewControllerProtocol {
	@IBOutlet private var tableView: UITableView!
	
	private let showSingleImageSegueIdentifier = "ShowSingleImage"
	private var alertPresenter: IAlertPresenterProtocol!
	private var presenter: IImageListPresenterProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		alertPresenter = AlertPresenter(delegate: self)
		
		tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
		
		if presenter?.photos.count == 0 {
			presenter?.fetchPhotosNextPage()
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		.lightContent
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == showSingleImageSegueIdentifier {
			guard let singleImageVC = segue.destination as? SingleImageViewController,
				  let indexPath = sender as? IndexPath else { return }
			
			let photo = presenter?.photos[indexPath.row]
			singleImageVC.photo = photo
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
	
	func updateTableViewAnimated(startIndex: Int, newCount: Int) {
		tableView.performBatchUpdates {
			var rows = [IndexPath]()
			for n in startIndex..<newCount {
				rows.append(IndexPath(row: n, section: 0))
			}
			tableView.insertRows(at: rows, with: .automatic)
		}
	}
	
	func configure(_ presenter: IImageListPresenterProtocol) {
		self.presenter = presenter
		self.presenter?.view = self
	}
	
	private func reloadRowForTable(indexPath: IndexPath) {
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
}

extension ImagesListViewController: IAlertPresenterDelegate {
	func showAlert(alert: UIAlertController) {
		present(alert, animated: true)
	}
}

extension ImagesListViewController: ImagesListCellDelegate {
	func imageListCellDidTapLike(_ cell: ImageListCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		guard let photo = presenter?.photos[indexPath.row] else { return }
		
		presenter?.changeLike(for: photo) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(_):
				cell.setIsLiked(isLike: photo.isLiked)
				self.reloadRowForTable(indexPath: indexPath)
			case .failure(let error):
				self.alertPresenter.preparingDataAndDisplay(alertText: "Не удалось установить like. \(error.localizedDescription)") { }
			}
		}
	}
}

extension ImagesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter?.photos.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reusableIdentifier, for: indexPath)
		
		guard let imageListCell = cell as? ImageListCell else {
			return UITableViewCell()
		}
		
		guard let photo = presenter?.photos[indexPath.row] else { return UITableViewCell() }
		
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
		guard let presenter = presenter else { return tableView.rowHeight }
		let photo = presenter.photos[indexPath.row]
		
		return presenter.getCellHeight(for: photo, tableViewWidth: tableView.bounds.width)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let photosCount = presenter?.photos.count ?? 0
		
		if indexPath.row + 1 == photosCount {
			presenter?.fetchPhotosNextPage()
		}
	}
}

