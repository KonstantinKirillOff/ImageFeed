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
    
    private let authService = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "bearerToken")
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
            guard let authVC = segue.destination as? AuthViewController else { return }
            authVC.authRouting = authService
            authVC.tokenStorage = tokenStorage
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
