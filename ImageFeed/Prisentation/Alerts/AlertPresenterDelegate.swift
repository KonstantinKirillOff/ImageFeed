//
//  AlertPresenterDelegate.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 17.02.2023.
//

import UIKit

protocol IAlertPresenterDelegate: AnyObject {
	func showAlert(alert: UIAlertController)
}
