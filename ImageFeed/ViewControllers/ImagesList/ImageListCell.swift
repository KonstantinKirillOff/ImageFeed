//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 04.01.2023.
//

import Foundation
import UIKit

final class ImageListCell: UITableViewCell {
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var heartButton: UIButton!
    @IBOutlet private var imageDateLabel: UILabel!
    @IBOutlet private var gradientLayer: UIView!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    static let reusableIdentifier = "ImagesListCell"
    
    func configCell(for cell: ImageListCell, indexPath: IndexPath, photo: String) {
        if let image = UIImage(named: photo) {
            cell.mainImageView.image = image
        } else {
            cell.mainImageView.image = UIImage(systemName: "photo")
        }
        
        if indexPath.row.isMultiple(of: 2) {
            cell.heartButton.setImage(UIImage(named: "Active") , for: .normal)
        } else {
            cell.heartButton.setImage(UIImage(named: "No Active") , for: .normal)
        }
        
        mainImageView.layer.cornerRadius = 16
        mainImageView.layer.masksToBounds = true
    
        gradientLayer.layer.cornerRadius = 16
        gradientLayer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        gradientLayer.layer.masksToBounds = true
        gradientLayer.alpha = 0.2
        
        imageDateLabel.textColor = UIColor(named: "YP White")
        imageDateLabel.text = dateFormatter.string(from: Date())
    }
}
