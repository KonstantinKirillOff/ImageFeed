//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 10.01.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var scrollView: UIScrollView!
	
	private var alertPresenter: IAlertPresenterProtocol!
	var photo: Photo!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		alertPresenter = AlertPresenter(delegate: self)
		
		scrollView.delegate = self
		scrollView.maximumZoomScale = 1.25
		scrollView.minimumZoomScale = 0.1
		
		setImage()
	}
	
	@IBAction private func backwardButtonTapped() {
		dismiss(animated: true)
	}
	
	@IBAction private func sharedButtonTapped() {
		if let image = imageView.image {
			let imageShare = [image]
			let activityVC = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
			self.present(activityVC, animated: true)
		}
	}
	
	private func setImage() {
		UIBlockingProgressHUD.show()
		if let imageURL = URL(string: photo.largeImageURL) {
			imageView.kf.setImage(with: imageURL) { [weak self] result in
				UIBlockingProgressHUD.dismiss()
				guard let self = self else { return }
				switch result {
				case .success(let imageResult):
					self.rescaleAndCenterImageInScrollView(image: imageResult.image)
				case .failure(_):
					self.showError()
				}
			}
		} else {
			imageView.image = UIImage(named: "StubCard")
		}
	}
	
	private func showError() {
		alertPresenter.preparingAlertWithRepeat(alertText: "Попробовать еще раз?") { [weak self] in
			guard let self = self else { return }
			self.setImage()
		}
	}
	
}

extension SingleImageViewController: IAlertPresenterDelegate {
	func showAlert(alert: UIAlertController) {
		self.present(alert, animated: true)
	}
}

extension SingleImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}
	
	private func rescaleAndCenterImageInScrollView(image: UIImage) {
		view.layoutIfNeeded()
		rescaleImageInScrollView(image: image)
		centerImage(image: image)
	}
	
	private func centerImage(image: UIImage) {
		let visibleRectSize = scrollView.bounds.size
		let newContentSize = scrollView.contentSize
		let x = (newContentSize.width - visibleRectSize.width) / 2
		let y = (newContentSize.height - visibleRectSize.height) / 2
		scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
	}
	
	private func rescaleImageInScrollView(image: UIImage) {
		let minZoomScale = scrollView.minimumZoomScale
		let maxZoomScale = scrollView.maximumZoomScale
		
		let visibleRectSize = scrollView.bounds.size
		let imageSize = image.size
		let hScale = visibleRectSize.width / imageSize.width
		let vScale = visibleRectSize.height / imageSize.height
		let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
		scrollView.setZoomScale(scale, animated: false)
		scrollView.layoutIfNeeded()
	}
}
