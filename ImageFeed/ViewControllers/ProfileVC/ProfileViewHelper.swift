//
//  ProfileViewHelper.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 19.03.2023.
//

import Foundation
import WebKit

protocol IProfileViewHelperProtocol {
	func cleanStorage()
	func cleanCookie()
}

final class ProfileViewHelper: IProfileViewHelperProtocol {
	func cleanStorage() {
		OAuth2TokenStorage.shared.removeToken()
	}
	
	func cleanCookie() {
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
			}
		}
	}
}
