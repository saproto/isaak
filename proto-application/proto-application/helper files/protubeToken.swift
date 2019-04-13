//
//  protubeToken.swift
//  proto-application
//
//  Created by Hessel Bierma on 03/04/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let protubeToken = try? newJSONDecoder().decode(ProtubeToken.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseProtubeToken { response in
//     if let protubeToken = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct ProtubeToken: Codable {
    let name: String?
    let photo: String?
    let token: String?
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
    func responseProtubeToken(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ProtubeToken>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
