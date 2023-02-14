//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    
    private let showGalleryFlowIdentifier = "showGalleryFlow"
    private let showAuthFlowIdentifier = "showAuthFlow"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage.shared.token  {
            fetchProfile(for: token)
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
    
    private func fetchProfile(for authToken: String) {
        profileService.getProfileData(for: authToken)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            OAuth2Service.shared.fetchAuthToken(by: code) { result in
                switch result {
                case .success(let token):
                    self.fetchProfile(for: token)
                    self.switchToTapBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    //TODO: show alert
                    print(error.localizedDescription)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
}
