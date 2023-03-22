//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 18.03.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
	
	func testViewControllerCallsPresenterViewDidLoad() throws {
		//given
		let storyboard = UIStoryboard(name: "Main", bundle: .main)
		let webViewVC = storyboard.instantiateViewController(identifier: "WebViewViewController") as! WebViewViewController
		
		let webViewPresenterSpy = WebViewPresenterSpy()
		webViewPresenterSpy.view = webViewVC
		webViewVC.presenter = webViewPresenterSpy
		
		//when
		let _ = webViewVC.view
		
		//then
		XCTAssertTrue(webViewPresenterSpy.presenterViewDidLoadCalled) //behaviour verification
	}
	
	func testPresenterCallsLoadRequest() throws {
		//given
		let webViewVCSpy = WebViewVCSpy()
		let webViewHelper = WebViewHelper()
		let webViewPresenter = WebViewPresenter(webViewHelper: webViewHelper)
		webViewPresenter.view = webViewVCSpy
		
		//when
		webViewPresenter.viewDidLoad()
		
		//then
		XCTAssertTrue(webViewVCSpy.loadDidCalled)
	}

	func testProgressVisibleWhenLessThenOne() throws {
		//given
		let webViewHelper = WebViewHelper()
		let webViewPresenter = WebViewPresenter(webViewHelper: webViewHelper)
		let progress: Float = 0.6
		
		//when
		let progressIsHidden = webViewPresenter.shouldHideProgress(for: progress)
		
		//then
		XCTAssertFalse(progressIsHidden)
	}
	
	func testProgressHiddenWhenOne() throws {
		//given
		let webViewHelper = WebViewHelper()
		let webViewPresenter = WebViewPresenter(webViewHelper: webViewHelper)
		let progress: Float = 1
		
		//when
		let isHidden = webViewPresenter.shouldHideProgress(for: progress)
		
		//then
		XCTAssertTrue(isHidden) //return value verification
	}
	
	func testAuthHelperAuthURL() throws {
		//given
		let standardConfiguration = AuthConfiguration.standard
		let webViewHelper = WebViewHelper(configuration: standardConfiguration)
		
		//when
		let urlRequest = webViewHelper.authRequest()!
		let urlString = urlRequest.url?.absoluteString ?? ""
		
		//then
		XCTAssertTrue(urlString.contains(standardConfiguration.baseURLString))
		XCTAssertTrue(urlString.contains("code"))
		XCTAssertTrue(urlString.contains(standardConfiguration.redirectURI))
		XCTAssertTrue(urlString.contains(standardConfiguration.accessScope))
		XCTAssertTrue(urlString.contains(standardConfiguration.accessKey))
	}
	
	func testCodeFromURL() throws {
		//given
		let standardConfiguration = AuthConfiguration.standard
		let webViewHelper = WebViewHelper(configuration: standardConfiguration)
		
		var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
		urlComponents.queryItems = [
			URLQueryItem(name: "code", value: "test code")
		]
		let url = urlComponents.url!
		
		//when
		let codeValue = webViewHelper.code(from: url)
		
		//then
		XCTAssertTrue(codeValue == "test code")
	}
	
}
