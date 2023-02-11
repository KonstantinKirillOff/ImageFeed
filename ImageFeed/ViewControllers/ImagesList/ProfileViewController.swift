//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 08.01.2023.
//

import UIKit
import ProgressHUD

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private lazy var userPickImage: UIImageView = {
        if let userImage = UIImage(named: "UserPick") {
            return configImage(image: userImage)
        }
        return UIImageView()
    }()
    
    private lazy var escapeButton: UIButton = {
        if let exitImage = UIImage(named: "Exit") {
            let button = UIButton.systemButton(with: exitImage, target: self, action: #selector(exitButtonTapped))
            button.tintColor = UIColor.ypRed
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            return button
        }
        return UIButton()
    }()
    
    private lazy var userName: UILabel = {
        let label = configLabel(text: "Екатерина Новикова")
        label.textColor = UIColor.ypWhite
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var userLogin: UILabel = {
        let label =  configLabel(text: "@ekaterina_nov")
        label.textColor = UIColor.ypGrey
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var userMessage: UILabel = {
        let label =  configLabel(text: "Hello, world!")
        label.textColor = UIColor.ypWhite
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypBlack
        setConstraints()
        getProfileData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        userPickImage.layer.cornerRadius = userPickImage.bounds.width / 2
    }

    private func configLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    private func configImage(image: UIImage) -> UIImageView {
        let imageElement = UIImageView(image: image)
        imageElement.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageElement)
        return imageElement
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPickImage.heightAnchor.constraint(equalToConstant: 70),
            userPickImage.widthAnchor.constraint(equalToConstant: 70),
            userPickImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userPickImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            escapeButton.heightAnchor.constraint(equalToConstant: 24),
            escapeButton.widthAnchor.constraint(equalToConstant: 24),
            escapeButton.centerYAnchor.constraint(equalTo: userPickImage.centerYAnchor),
            escapeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            
            userName.leadingAnchor.constraint(equalTo: userPickImage.leadingAnchor),
            userName.topAnchor.constraint(equalTo: userPickImage.bottomAnchor, constant: 8),
            
            userLogin.leadingAnchor.constraint(equalTo: userPickImage.leadingAnchor),
            userLogin.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            
            userMessage.leadingAnchor.constraint(equalTo: userPickImage.leadingAnchor),
            userMessage.topAnchor.constraint(equalTo: userLogin.bottomAnchor, constant: 8)
        ])
    }
    
    private func getProfileData() {
        ProgressHUD.show()
        guard let authToken = OAuth2TokenStorage.shared.token else { return }
        profileService.fetchProfile(authToken) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                if let profile = self.convertToProfile(from: profileResult) {
                    self.userName.text = profile.name
                    self.userLogin.text = profile.loginName
                    self.userMessage.text = profile.bio
                }
                self.getImageProfile(profileResult: profileResult)
            case .failure(_): break
                //TODO: show alert
            }
        }
    }
    
    private func convertToProfile(from profileResult: ProfileResult) -> Profile? {
        return Profile(username: profileResult.userName,
                       firstName: profileResult.firstName,
                       lastName: profileResult.lastName,
                       bio: profileResult.bio ?? "",
                       profileImage: UIImage())
    }
    
    private func getImageProfile(profileResult: ProfileResult) {
        if let imageURL = profileResult.profileImage?.medium {
            profileService.fetchImage(urlString: imageURL) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let imageData):
                    self.userPickImage.image = UIImage(data: imageData) ?? UIImage()
                    ProgressHUD.dismiss()
                case .failure(_): break
                    //TODO: alert
                }
            }
        }
    }
    
    @objc private func exitButtonTapped() {
        
    }
    
}
