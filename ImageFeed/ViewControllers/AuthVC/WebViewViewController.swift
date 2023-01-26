//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 24.01.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
}
