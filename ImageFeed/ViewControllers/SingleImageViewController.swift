//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 10.01.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1.25
        scrollView.minimumZoomScale = 0.1
    }
    
    @IBAction func backwardButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func sharedButtonTapped() {
        if let image = image {
            let imageShare = [image]
            let activityVC = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
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
