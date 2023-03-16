//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 24.01.2023.
//

import UIKit
import WebKit

public protocol IWebViewControllerProtocol: AnyObject {
	var presenter: IWebViewPresenterProtocol? { get set }
	func load(urlRequest: URLRequest)
	func setProgressValue(_ newValue: Float)
	func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, IWebViewControllerProtocol{
	@IBOutlet private var webView: WKWebView!
	@IBOutlet private var progressView: UIProgressView!
	
	weak var delegate: IWebViewViewControllerDelegate!
	weak var presenter: IWebViewPresenterProtocol?
	
	private var estimatedProgressObservation: NSKeyValueObservation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		webView.navigationDelegate = self
		
		presenter?.viewDidLoad()
		estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
			guard let self = self else { return }
			self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
		}
	}
	
	@IBAction private func didTapBackButton() {
		delegate.webViewViewControllerDidCancel(self)
	}
	
	func setProgressValue(_ newValue: Float) {
		progressView.setProgress(newValue, animated: true)
	}
	
	func setProgressHidden(_ isHidden: Bool) {
		progressView.isHidden = isHidden
	}
	
	func load(urlRequest: URLRequest) {
		webView.load(urlRequest)
	}
}

extension WebViewViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if let url = navigationAction.request.url,
		   let code = presenter?.code(from: url) {
			delegate.webViewViewController(self, didAuthenticateWith: code)
			decisionHandler(.cancel)
		} else {
			decisionHandler(.allow)
		}
	}
}
