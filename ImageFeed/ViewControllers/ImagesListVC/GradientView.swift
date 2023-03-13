//
//  GradientView.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 05.01.2023.
//

import Foundation
import UIKit

final class GradientView: UIView {
	
	private let gradientLayer = CAGradientLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupGradient()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = bounds
	}
	
	private func setupGradient() {
		self.layer.addSublayer(gradientLayer)
		setupGradientColor()
	}
	
	private func setupGradientColor() {
		gradientLayer.colors = [
			UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
			UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
		]
		gradientLayer.locations = [0, 1]
		gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
		
		gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0))
		
		gradientLayer.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
	}
}
