//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 10.01.2023.
//

import UIKit

class SingleImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func backwardButtonTapped() {
        dismiss(animated: true)
    }
    

}
