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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = OAuth2TokenStorage.shared.token  {
            switchToTapBarController()
        } else {
            performSegue(withIdentifier: showAuthFlowIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthFlowIdentifier {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let authVC = navigationController.topViewController as? AuthViewController else { return }
            authVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTapBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            OAuth2Service.shared.fetchAuthToken(by: code) { result in
                switch result {
                case .success(_):
                    self.switchToTapBarController()
                case .failure(let error):
                    //TODO: show alert
                    print(error.localizedDescription)
                }
            }
        }
    }
}
