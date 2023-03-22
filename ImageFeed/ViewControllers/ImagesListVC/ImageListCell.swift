//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 04.01.2023.
//

import Foundation
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
	func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
	@IBOutlet weak private var mainImageView: UIImageView!
	@IBOutlet weak private var heartButton: UIButton!
	@IBOutlet weak private var imageDateLabel: UILabel!
	@IBOutlet weak private var gradientLayer: UIView!
	
	weak var delegate: ImagesListCellDelegate?
	
	private lazy var dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .none
		return dateFormatter
	}()
	
	var reloadRowFunction: (() -> Void)?
	
	static let reusableIdentifier = "ImagesListCell"
	
	override func prepareForReuse() {
		super.prepareForReuse()
		mainImageView.kf.cancelDownloadTask()
	}
	
	@IBAction private func heartButtonPressed() {
		delegate?.imageListCellDidTapLike(self)
	}
	
	func configCell(photo: Photo) {
		if let imageURL = URL(string: photo.thumbImageURL) {
			let processor = RoundCornerImageProcessor(cornerRadius: 16)
			mainImageView.kf.indicatorType = .activity
			mainImageView.kf.setImage(with: imageURL,
									  placeholder: UIImage(named: "StubCard"),
									  options: [.processor(processor)]) { [weak self] _ in
				guard let self = self else { return }
				self.reloadRowFunction?()
			}
		} else {
			mainImageView.image = UIImage(named: "StubCard")
		}
		
		gradientLayer.layer.cornerRadius = 16
		gradientLayer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
		gradientLayer.layer.masksToBounds = true
		gradientLayer.alpha = 0.2
		
		imageDateLabel.textColor = UIColor(named: "YP White")
		imageDateLabel.text =  photo.createAt != nil ? dateFormatter.string(from: photo.createAt!) : ""
		
		setIsLiked(isLike: photo.isLiked)
		heartButton.accessibilityIdentifier = "heartButton"
	}
	
	func setIsLiked(isLike: Bool) {
		if isLike {
			heartButton.setImage(UIImage(named: "Active") , for: .normal)
		} else {
			heartButton.setImage(UIImage(named: "No Active") , for: .normal)
		}
	}
}
