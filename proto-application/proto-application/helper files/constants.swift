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

let pSiteBlue = UIColor(red: 0, green: 170/255, blue: 192/255, alpha: 1)
let protoGreen = UIColor(red: 142/255, green: 214/255, blue: 58/255, alpha: 1)

struct OAuth {
    static var baseURL = "https://www.proto.utwente.nl"
    
    static var headers: HTTPHeaders = ["Authorization" : "Bearer " + keychain.get("access_token")!,
                                       "Accept" : "application/json"]
    
    static var consumerKey = "3"
    static var consumerSecret = "sXnj8OzgsAe2do4Gb0fjmZBAESQwt2lruqPLvR8y"
    static var authorizeURL = baseURL + "/oauth/authorize?client_id=3&response_type=code&redirect_uri=saproto://oauth_callback&scope=*"
    static var accesTokenURL = baseURL + "/oauth/token"
    static var callbackURL = "saproto://oauth_callback"
    
    static var profileInfo = baseURL + "/api/user/info"
    static var profilePicture = baseURL + "/api/user/profile_picture"
    
    static var upcomingEvents = baseURL + "/api/events/upcoming/for_user"
    static var signup = baseURL + "/api/events/signup/"
    static var signout = baseURL + "/api/events/signout/"
    
    static var orderlines = baseURL + "/api/user/orders"
    static var total_month = baseURL + "/api/user/orders/total_month"
    static var next_withdrawal = baseURL + "/api/user/orders/next_withdrawal"
    
    static var news = baseURL + "/api/news"
    
    static var omnomQR = baseURL + "/api/user/qr_auth_approve/"
    static var omnomQRInfo = baseURL + "/api/user/qr_auth_info/"

    static var protubeToken = baseURL + "/api/user/token"
}
