//
//  Event.swift
//  proto-application
//
//  Created by Hessel Bierma on 12/12/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//


// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseEventElement { response in
//     if let eventElement = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - EventElement
struct EventElement: Codable {
    let id: Int?
    let title, eventDescription: String?
    let start, end: Double?
    let location: String?
    let current, over, hasSignup: Bool?
    let price: Double?
    let noShowFee: Int?
    let userSignedup, userSignedupBackup: Bool?
    let userSignedupID: Int?
    let canSignup, canSignupBackup, canSignout: Bool?
    let tickets: [Ticket]?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case eventDescription = "description"
        case start, end, location, current, over
        case hasSignup = "has_signup"
        case price
        case noShowFee = "no_show_fee"
        case userSignedup = "user_signedup"
        case userSignedupBackup = "user_signedup_backup"
        case userSignedupID = "user_signedup_id"
        case canSignup = "can_signup"
        case canSignupBackup = "can_signup_backup"
        case canSignout = "can_signout"
        case tickets
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseTicket { response in
//     if let ticket = response.result.value {
//       ...
//     }
//   }

// MARK: - Ticket
struct Ticket: Codable {
    let barcode: String?
    let scanned: String?
    let id: Int?
}

typealias Event = [EventElement]

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
    func responseEvent(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Event>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
