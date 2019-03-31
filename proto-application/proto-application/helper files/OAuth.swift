//
//  OAuth.swift
//  proto-application
//
//  Created by Hessel Bierma on 21/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire


func isLoggedIn() -> Bool{
    
    if keychain.get("access_token") as String? == nil{
        return false
    }else{
        return true
    }

}

func tokenRequest(token: Any, completion: @escaping (_ result: Bool) -> Void){
    
    let headers: HTTPHeaders = [
        "content-type"  : "application/json"]
    let parameters: Parameters = [
        "grant_type"    : "authorization_code",
        "code"          : token,
        "redirect_uri"  : OAuth.callbackURL,
        "client_id"     : OAuth.consumerKey,
        "client_secret" : OAuth.consumerSecret
    ]
    
    Alamofire.request(OAuth.accesTokenURL,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers)
        .responseObject { (response: DataResponse<OAuthTokenResponse>) in
        switch response.result{
        case .success:
            keychain.set((response.result.value?.access_token)!, forKey: "access_token")
            keychain.set((response.result.value?.refresh_token)!, forKey: "refresh_token")
            completion(true)
            break
        case .failure:
            completion(false)
            break
        }
    }
}

func tryAccessToken(completion: @escaping (_ result: Bool) -> Void){
    let testReq = Alamofire.request(OAuth.next_withdrawal,
                                    method: .get,
                                    parameters: [:],
                                    encoding: URLEncoding.methodDependent,
                                    headers: OAuth.headers)
    testReq.response{response in
        if String(describing: response).prefix(0) == "<" {
            completion(false)
        }else{
            completion(true)
        }
    }
}

struct OAuthTokenResponse: ResponseObjectSerializable, CustomStringConvertible {
    let access_token: String
    let refresh_token: String
    let expires_in: Double

    var description: String {
        return "OAuthTokenResponse: { access_token: \(access_token), refresh_token: \(refresh_token), expires_in: \(expires_in) }"
    }

    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let access_token = representation["access_token"] as? String,
            let refresh_token = representation["refresh_token"] as? String,
            let expires_in = representation["expires_in"] as? Double
            else { return nil }

        self.access_token = access_token
        self.refresh_token = refresh_token
        self.expires_in = expires_in
    }
}
