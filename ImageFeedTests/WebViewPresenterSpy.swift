//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 18.03.2023.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: IWebViewPresenterProtocol {
	var view: ImageFeed.IWebViewControllerProtocol?
	var presenterViewDidLoadCalled: Bool = false
	
	func viewDidLoad() {
		presenterViewDidLoadCalled = true
	}
	
	func didUpdateProgressValue(_ newValue: Double) {
		
	}
	
	func code(from url: URL) -> String? {
		nil
	}
	
	
}
