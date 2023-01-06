//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 04.01.2023.
//

import Foundation
import UIKit

final class ImageListCell: UITableViewCell {
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var heartButton: UIButton!
    
    static let reusableIdentifier = "ImagesListCell"
}
