//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import UIKit

class SplashViewController: UIViewController {
    private let showGalleryFlowIdentifier = "showGalleryFlow"
    private let showAuthFlowIdentifier = "showAuthFlow"
    private let authService = OAuth2Service.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaults.standard.removeObject(forKey: "bearerToken")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = OAuth2TokenStorage().token  {
            performSegue(withIdentifier: showGalleryFlowIdentifier, sender: nil)
        } else {
            performSegue(withIdentifier: showAuthFlowIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthFlowIdentifier {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let authVC = navigationController.topViewController as? AuthViewController else { return }
            authVC.authRouting = authService
            authVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        <#code#>
    }
    
    private func switchToTapBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid configuration")
        }
    }
}
