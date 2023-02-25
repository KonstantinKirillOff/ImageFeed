//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
	static let shared = OAuth2TokenStorage()
	private let keychainWrapper =  KeychainWrapper.standard
	
	var token: String? {
		get {
			keychainWrapper.string(forKey: Constants.bearerToken)
		}
		set {
			guard let newValue = newValue else { return }
			keychainWrapper.set(newValue, forKey: Constants.bearerToken)
		}
	}
	
	func removeToken() -> Bool {
		keychainWrapper.removeObject(forKey: Constants.bearerToken)
	}
	
	private init() {}
}
