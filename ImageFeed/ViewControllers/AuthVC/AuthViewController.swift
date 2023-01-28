//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 26.01.2023.
//

import UIKit

class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"

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
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
