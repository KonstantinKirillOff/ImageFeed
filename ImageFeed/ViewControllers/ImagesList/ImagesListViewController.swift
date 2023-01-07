//
//  ViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 27.12.2022.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    private let photosName = Array(0..<20).map({"\($0)"})
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reusableIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, indexPath: indexPath)
        return imageListCell
    }
    
    func configCell(for cell: ImageListCell, indexPath: IndexPath) {
        let photo = photosName[indexPath.row]
        
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
        
        cell.mainImageView.layer.cornerRadius = 16
        cell.mainImageView.layer.masksToBounds = true
    
        cell.gradientLayer.layer.cornerRadius = 16
        cell.gradientLayer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cell.gradientLayer.layer.masksToBounds = true
        cell.gradientLayer.alpha = 0.2
        
        cell.imageDateLabel.textColor = UIColor(named: "YP White")
        cell.imageDateLabel.text = dateFormatter.string(from: Date())
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

