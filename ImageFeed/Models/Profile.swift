//
//  Profile.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 28.01.2023.
//

import UIKit

struct Profile {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    var loginName: String {
        "@\(username)"
    }
}
