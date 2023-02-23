//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 23.02.2023.
//

import Foundation

protocol IWebViewViewControllerDelegate: AnyObject {
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWith code: String)
	func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
