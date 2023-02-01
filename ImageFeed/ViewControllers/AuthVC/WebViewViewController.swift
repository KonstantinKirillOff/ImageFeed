//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 24.01.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWith code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

fileprivate struct AuthConstants {
    static let responseType = "code"
    static let authPath = "/oauth/authorize"
    static let codePath = "/oauth/authorize/native"
}

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlRequest = authRequest() else {
            fatalError("Bad auth request!")
        }
        webView.load(urlRequest)
        webView.navigationDelegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    @IBAction private func didTapBackButton() {
        delegate.webViewViewControllerDidCancel(self)
    }
    
    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func authRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.baseURLString) else { return nil }
        urlComponents.path = AuthConstants.authPath
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: AuthConstants.responseType),
            URLQueryItem(name: "scope", value: Constants.accessScope),
        ]
        if let url = urlComponents.url {
            return URLRequest(url: url)
        }
        return nil
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //print("AUTH",navigationAction.request.url!)
        if let code = code(from: navigationAction) {
            delegate.webViewViewController(self, didAuthenticateWith: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString) ,
           urlComponents.path == AuthConstants.codePath,
           let items = urlComponents.queryItems,
           let codeItems = items.first(where: { $0.name == AuthConstants.responseType }) {
            return codeItems.value
        } else {
            return nil
        }
    }
}
