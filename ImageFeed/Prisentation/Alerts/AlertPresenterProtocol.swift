//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 17.02.2023.
//

import Foundation

protocol IAlertPresenterProtocol {
	func preparingDataAndDisplay(alertText: String, handler: @escaping () -> Void)
}
