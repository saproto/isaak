//
//  constants.swift
//  proto-application
//
//  Created by Hessel Bierma on 14/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import Foundation

struct OAuth {
    static var consumerKey = "3"
    static var consumerSecret = "sXnj8OzgsAe2do4Gb0fjmZBAESQwt2lruqPLvR8y"
    static var authorizeURL = "https://www.proto.utwente.nl/oauth/authorize?client_id=3&response_type=code&redirect_uri=saproto://oauth_callback&scope=*"
    static var  accesTokenURL = "https://proto.utwente.nl/oauth/token"
    static var callbackURL = "saproto://oauth_callback"
}
