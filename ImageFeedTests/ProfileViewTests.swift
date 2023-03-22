//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 22.03.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {

    func testDidCookieCleanedAfterLogOutProfileVC() throws {

		//given
		let profileVC = ProfileViewController()
		let profileHelper = ProfileViewHelperSpy()
		let presenter = ProfileViewPresenterSpy(helper: profileHelper)
		profileVC.configure(presenter)

		//when
		profileVC.logOutFromProfile()

		//then
		XCTAssertTrue(profileHelper.didCookieCleaned)

    }
	
	func testDidStorageCleanedAfterLogOutProfileVC() throws {

		//given
		let profileVC = ProfileViewController()
		let profileHelper = ProfileViewHelperSpy()
		let presenter = ProfileViewPresenterSpy(helper: profileHelper)
		profileVC.configure(presenter)

		//when
		profileVC.logOutFromProfile()

		//then
		XCTAssertTrue(profileHelper.didStorageCleaned)
	}
	
	func testChangeRootVCAfterLogOut() throws {
		
		//given
		let profileVC = ProfileViewController()
		let profileHelper = ProfileViewHelper()
		let presenter = ProfileViewPresenter(profileViewHelper: profileHelper)
		profileVC.configure(presenter)
		
		//when
		let window = UIApplication.shared.windows.first!
		profileVC.logOutFromProfile()
		
		
		//then
		XCTAssertTrue(window.rootViewController is SplashViewController)
	}
	
	
}
