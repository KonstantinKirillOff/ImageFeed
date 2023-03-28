//
//  ProfileViewHelperSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 22.03.2023.
//

import Foundation
@testable import ImageFeed

final class ProfileViewHelperSpy: IProfileViewHelperProtocol {
	var didStorageCleaned: Bool = false
	var didCookieCleaned: Bool = false
	
	func cleanStorage() {
		didStorageCleaned = true
	}
	
	func cleanCookie() {
		didCookieCleaned = true
	}
	
	
}
