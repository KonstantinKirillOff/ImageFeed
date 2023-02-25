//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 23.02.2023.
//

import Foundation

protocol IAuthViewControllerDelegate: AnyObject {
	func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
