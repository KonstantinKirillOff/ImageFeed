//
//  Constants.swift
//  ImageFeed
//
//  Created by Konstantin Kirillov on 21.01.2023.
//

import Foundation

let AccessKey = "DMGBd_bhpgkA43sh0XwoPis264uPwYAHhxnDGdQVaaI"
let SecretKey = "gLMPi52tnl_lGIl8WLh70nW6Bq1XhqZzbmdZmgfPFyI"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultApiBaseURLString = "https://api.unsplash.com"
let BaseURLString = "https://unsplash.com"
let BaseAuthTokenPath = "/oauth/token"

struct AuthConfiguration {
	//MARK: Unsplash api base paths
	let defaultApiBaseURLString: String
	let baseURLString: String
	let baseAuthTokenPath: String
	
	//MARK: Unsplash api constants
	let accessKey: String
	let secretKey: String
	let redirectURI: String
	let accessScope: String
	
	static var standard: AuthConfiguration {
		return AuthConfiguration(accessKey: AccessKey, secretKey: SecretKey, redirectURI: RedirectURI,
								 accessScope: AccessScope, defaultApiBaseURLString: DefaultApiBaseURLString,
								 baseURLString: BaseURLString, baseAuthTokenPath: BaseAuthTokenPath)
	}
	
	init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultApiBaseURLString: String, baseURLString: String,
		 baseAuthTokenPath: String) {
		self.accessKey = accessKey
		self.accessScope = accessScope
		self.redirectURI = redirectURI
		self.secretKey = secretKey
		self.defaultApiBaseURLString = defaultApiBaseURLString
		self.baseURLString = baseURLString
		self.baseAuthTokenPath = baseAuthTokenPath
	}
}


struct Constants {
    //MARK: Unsplash constants
	static let photosPerPage = 10
    
    //MARK: Storage constants
    static let bearerToken = "bearerToken"
}

struct NotificationConstants {
	static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
	static let imageListDidChange = "ImageListDidChange"
}


