//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 24.01.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private lazy var logoImage: UIImageView = {
        if let image = UIImage(named: "unsplashLogo") {
            let imageElement =  UIImageView(image: image)
            imageElement.translatesAutoresizingMaskIntoConstraints = false
            return imageElement
        }
        return UIImageView()
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "YP White")
        button.layer.cornerRadius = 16
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        setupSubviews(logoImage, enterButton)
        setConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 60),
            logoImage.widthAnchor.constraint(equalToConstant: 60),
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            enterButton.heightAnchor.constraint(equalToConstant: 48),
            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    @objc private func enterButtonPressed() {
        navigationController?.pushViewController(WebViewViewController(), animated: true)
    }
}
