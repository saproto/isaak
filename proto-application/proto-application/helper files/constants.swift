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
    static var authorizeURL = "https://www.proto.utwente.nl/oauth/authorize?client_id=3&response_type=code&redirect_uri=saproto://oauth_callback&scope=*"
    static var  accesTokenURL = "https://proto.utwente.nl/oauth/token"
    static var callbackURL = "saproto://oauth_callback"
    static var profileInfo = "https://www.proto.utwente.nl/api/user/info"
    static var upcomingEvents = "https://www.proto.utwente.nl/api/events/upcoming"
    static var profilePicture = "https://www.proto.utwente.nl/api/user/profile_picture"
    static var orderlines = "https://www.proto.utwente.nl/api/user/orders"
    static var total_month = "https://www.proto.utwente.nl/api/user/orders/total_month"
    static var next_withdrawal = "https://www.proto.utwente.nl/api/user/orders/next_withdrawal"
    static var news = "https://www.proto.utwente.nl/api/news"
    static var headers: HTTPHeaders = ["Authorization" : "Bearer " + keychain.get("access_token")!]
}
