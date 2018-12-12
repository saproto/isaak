//
//  Event.swift
//  proto-application
//
//  Created by Hessel Bierma on 12/12/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let event = try? newJSONDecoder().decode(Event.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseEvent { response in
//     if let event = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

typealias Event = [EventElement]

struct EventElement: Codable {
    let id: Int?
    let title, description: String?
    let start, end: Double?
    let location: String?
    let current, over: Bool?
}

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
    func responseEvent(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Event>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
