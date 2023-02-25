//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 17.02.2023.
//

import UIKit

struct AlertPresenter: IAlertPresenterProtocol {
	weak var delegate: IAlertPresenterDelegate?
	
	func preparingDataAndDisplay(alertText: String, handler: @escaping () -> Void ) {
		let alert = UIAlertController(title: "Что-то пошло не так",
									  message: alertText,
									  preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
			handler()
		}
		
		alert.addAction(alertAction)
		delegate?.showAlert(alert: alert)
	}
}
