//
//  refresh.swift
//  proto-application
//
//  Created by Hessel Bierma on 21/05/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseRefresh { response in
//     if let refresh = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Refresh
struct Refresh: Codable {
    let tokenType: String?
    let expiresIn: Int?
    let accessToken, refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseRefresh(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Refresh>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
