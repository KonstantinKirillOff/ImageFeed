//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 04.01.2023.
//

import Foundation
import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
	@IBOutlet weak private var mainImageView: UIImageView!
	@IBOutlet weak private var heartButton: UIButton!
	@IBOutlet weak private var imageDateLabel: UILabel!
	@IBOutlet weak private var gradientLayer: UIView!
	
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
		if let createData = photo.createAt {
			imageDateLabel.text =  dateFormatter.string(from: createData)
		}
		
		if photo.isLiked {
			heartButton.setImage(UIImage(named: "Active") , for: .normal)
		} else {
			heartButton.setImage(UIImage(named: "No Active") , for: .normal)
		}
	}
}

//old version
//  func configCell(for cell: ImageListCell, indexPath: IndexPath, photo: String) {
//        if let image = UIImage(named: photo) {
//            cell.mainImageView.image = image
//        } else {
//            cell.mainImageView.image = UIImage(systemName: "photo")
//        }
//
//        if indexPath.row.isMultiple(of: 2) {
//            cell.heartButton.setImage(UIImage(named: "Active") , for: .normal)
//        } else {
//            cell.heartButton.setImage(UIImage(named: "No Active") , for: .normal)
//        }
//
//        mainImageView.layer.cornerRadius = 16
//        mainImageView.layer.masksToBounds = true
//
//        gradientLayer.layer.cornerRadius = 16
//        gradientLayer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        gradientLayer.layer.masksToBounds = true
//        gradientLayer.alpha = 0.2
//
//        imageDateLabel.textColor = UIColor(named: "YP White")
//        imageDateLabel.text = dateFormatter.string(from: Date())
