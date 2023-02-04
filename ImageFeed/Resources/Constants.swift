//
//  Constants.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 21.01.2023.
//

import Foundation

struct Constants {
    
    //MARK: Unsplash api base paths
    static let defaultApiBaseURLString = "https://api.unsplash.com"
    static let baseURLString = "https://unsplash.com"
    static let baseAuthTokenPath = "/oauth/token"
    
    //MARK: Unsplash api constants
    static let accessKey = "DMGBd_bhpgkA43sh0XwoPis264uPwYAHhxnDGdQVaaI"
    static let secretKey = "gLMPi52tnl_lGIl8WLh70nW6Bq1XhqZzbmdZmgfPFyI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    //MARK: Storage constants
    static let bearerToken = "bearerToken"
}
