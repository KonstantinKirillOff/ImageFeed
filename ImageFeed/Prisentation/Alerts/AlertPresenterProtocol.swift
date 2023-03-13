//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 17.02.2023.
//

import UIKit

protocol IAlertPresenterProtocol {
	func preparingDataAndDisplay(alertText: String, handler: @escaping () -> Void)
	func preparingAlertWithRepeat(alertText: String, handler: @escaping () -> Void )
	func preparingAlertController(alertTitle: String, alertMessage: String, alertActions: [UIAlertAction])
}
