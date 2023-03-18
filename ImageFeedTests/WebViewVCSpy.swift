//
//  WebViewWCSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 18.03.2023.
//

import Foundation
import ImageFeed

final class WebViewVCSpy: IWebViewControllerProtocol {
	var presenter: ImageFeed.IWebViewPresenterProtocol?
	var loadDidCalled: Bool = false
	
	func load(urlRequest: URLRequest) {
		loadDidCalled = true
	}
	
	func setProgressValue(_ newValue: Float) {
		
	}
	
	func setProgressHidden(_ isHidden: Bool) {
		
	}
	
	
}
