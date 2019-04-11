//
//  constants.swift
//  proto-application
//
//  Created by Hessel Bierma on 14/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire

let keychain = KeychainSwift()

struct OAuth {
    static var consumerKey = "3"
    static var consumerSecret = "sXnj8OzgsAe2do4Gb0fjmZBAESQwt2lruqPLvR8y"
    static var authorizeURL = baseURL + "/oauth/authorize?client_id=3&response_type=code&redirect_uri=saproto://oauth_callback&scope=*"
    static var accesTokenURL = baseURL + "/oauth/token"
    static var callbackURL = "saproto://oauth_callback"
    
    static var baseURL = "https://www.proto.utwente.nl"
    static var headers: HTTPHeaders = ["Authorization" : "Bearer " + keychain.get("access_token")!]
    
    static var profileInfo = baseURL + "/api/user/info"
    static var profilePicture = baseURL + "/api/user/profile_picture"
    
    static var upcomingEvents = baseURL + "/api/events/upcoming"
    
    static var orderlines = baseURL + "/api/user/orders"
    static var total_month = baseURL + "/api/user/orders/total_month"
    static var next_withdrawal = baseURL + "/api/user/orders/next_withdrawal"
    
    static var news = baseURL + "/api/news"
    
    static var omnomQR = baseURL + "/api/user/qr_auth_approve/"
    static var omnomQRInfo = baseURL + "api/user/qr_auth_info/"

}
