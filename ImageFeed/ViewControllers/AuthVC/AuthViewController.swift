//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 26.01.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    var authRouting: OAuth2ServiceRouting!
    var tokenStorage: OAuth2TokenStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("token: \(tokenStorage.token!)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewVC = segue.destination as? WebViewViewController else { return }
            webViewVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWith code: String) {
        authRouting.fetchAuthToken(by: code) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let token):
                self.tokenStorage.token = token
                print("token: \(token)")
            case .failure(_):
                print("error")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
