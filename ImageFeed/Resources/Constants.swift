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
    static let accessKey = "LUMG6YSLoGTass_HzRDzERd_dmrCMBSHpxqku6yl7P8"
    static let secretKey = "KKuyMqa_C2GwSdAQwUUxR3jOGTm5C3zeUS1mXD4GZkM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
	static let photosPerPage = 10
    
    //MARK: Storage constants
    static let bearerToken = "bearerToken"
}

struct NotificationConstants {
	static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
	static let imageListDidChange = "ImageListDidChange"
}
