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
	
	func preparingAlertWithRepeat(alertText: String, handler: @escaping () -> Void ) {
		let alert = UIAlertController(title: "Что-то пошло не так",
									  message: alertText,
									  preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Не надо", style: .default)
		let alertRepeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
			handler()
		}
		
		alert.addAction(alertAction)
		alert.addAction(alertRepeatAction)
		
		delegate?.showAlert(alert: alert)
	}
	
	func preparingAlertController(alertTitle: String, alertMessage: String, alertActions: [UIAlertAction]) {
		let alert = UIAlertController(title: alertTitle,
									  message: alertMessage,
									  preferredStyle: .alert)
		
		alertActions.forEach { action in
			alert.addAction(action)
		}
		
		delegate?.showAlert(alert: alert)
	}
}
