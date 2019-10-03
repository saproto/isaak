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

var events: Event = []

func retrieveProtubeToken(){
    let protubeTokenReq = Alamofire.request(OAuth.protubeToken,
                                            method: .get,
                                            parameters: [:],
                                            encoding: URLEncoding.methodDependent,
                                            headers: OAuth.headers)
    protubeTokenReq.responseProtubeToken{ response in
        let token = response.result.value!
        keychain.set(token.token!, forKey: "protube_token")
    }
}

func tokenRequest(token: Any, completion: @escaping (_ result: Bool) -> Void){
    
    let headers: HTTPHeaders = [
        "content-type"  : "application/x-www-form-urlencoded"]
    let parameters: Parameters = [
        "grant_type"    : "authorization_code",
        "code"          : token as! String,
        "redirect_uri"  : OAuth.callbackURL,
        "client_id"     : OAuth.consumerKey,
        "client_secret" : OAuth.consumerSecret
    ]
    
    let tokenReq = Alamofire.request(OAuth.accesTokenURL,
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.methodDependent,
                      headers: headers)
    tokenReq.responseObject { (response: DataResponse<OAuthTokenResponse>) in
            
        print(parameters)
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

func refreshToken(completion: @escaping (_ result: Bool) -> Void){
    let headers: HTTPHeaders = [
        "content-type" : "application/x-www-form-urlencoded"]
    let parameters: Parameters = [
        "grant_type"    : "refresh_token",
        "refresh_token" : keychain.get("refresh_token")!,
        "client_id"     : OAuth.consumerKey,
        "client_secret" : OAuth.consumerSecret
    ]
    
    let refreshreq = Alamofire.request(OAuth.accesTokenURL,
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.methodDependent,
                      headers: headers)
    debugPrint(refreshreq)
    refreshreq.responseRefresh{ response in
        print("refreshtokenrequest: ")
        print(response.response?.statusCode)
        switch response.response?.statusCode{
        case 200:
            let refresh = response.result.value!
            keychain.set(refresh.refreshToken!, forKey: "refresh_token")
            keychain.set(refresh.accessToken!, forKey: "access_token")
            completion(true)
        default:
            keychain.clear()
            completion(false)
        }
    }
}

func tryAccessToken(completion: @escaping (_ result: Bool) -> Void){
    print("starting token check")
    let testReq = Alamofire.request(OAuth.next_withdrawal,
                                    method: .get,
                                    parameters: [:],
                                    encoding: URLEncoding.methodDependent,
                                    headers: OAuth.headers)
    //debugPrint(testReq)
    testReq.responseString{response in
        print("response code: ")
        print(response.response?.statusCode)
        print("validating token check")
        switch response.response?.statusCode{
            case 200:
                print(response.result.value!)
                completion(true)
            default:
                completion(false)
                print(response.result.value!)
        }
    }
}

func saveCallingName(){
    let callingName = Alamofire.request(OAuth.profileInfo,
                                        method: .get,
                                        parameters: [:],
                                        encoding: URLEncoding.methodDependent,
                                        headers: OAuth.headers)
    
    callingName.responseProfileInfo{ response in
        let info = response.result.value!
        keychain.set(info.callingName!, forKey: "calling_name")
    }
}

func refreshEvents(){
    let eventsRequest = Alamofire.request(OAuth.upcomingEvents,
                                          method: .get,
                                          parameters: [:],
                                          encoding: URLEncoding.methodDependent,
                                          headers: OAuth.headers)
    //debugPrint(eventsRequest)
    eventsRequest.responseEvent { response in
        switch response.result{
        case .success:
            events = []
            let eventsResp = response.result.value
            for i in 0 ... (eventsResp?.count)! - 1{
                events.append(eventsResp![i])
            }
            
        case .failure:
            print("retreiving events failed")
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
