//
//  orderlines.swift
//  proto-application
//
//  Created by Hessel Bierma on 12/03/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseOrderline { response in
//     if let orderline = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

typealias Orderline = [OrderlineElement]

struct OrderlineElement: Codable {
    let id, userID: Int?
    let cashierID: Int?
    let productID: Int?
    let originalUnitPrice: Double?
    let units: Int?
    let totalPrice: Double?
//    let payedWithCash: String?
//    let payedWithMollie: JSONNull?
//    let payedWithWithdrawal: Int?
//    let description: JSONNull?
    let createdAt, updatedAt: String?
    let product: Product?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cashierID = "cashier_id"
        case productID = "product_id"
        case originalUnitPrice = "original_unit_price"
        case units
        case totalPrice = "total_price"
//        case payedWithCash = "payed_with_cash"
//        case payedWithMollie = "payed_with_mollie"
//        case payedWithWithdrawal = "payed_with_withdrawal"
//        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case product
    }
}

struct Product: Codable {
    let id, accountID: Int?
    let imageID: Int?
    let name: String?
    let price: Double?
    let calories: Int?
    let supplierID: String?
    let stock, preferredStock, maxStock, supplierCollo: Int?
    let isVisible, isAlcoholic, isVisibleWhenNoStock: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case accountID = "account_id"
        case imageID = "image_id"
        case name, price, calories
        case supplierID = "supplier_id"
        case stock
        case preferredStock = "preferred_stock"
        case maxStock = "max_stock"
        case supplierCollo = "supplier_collo"
        case isVisible = "is_visible"
        case isAlcoholic = "is_alcoholic"
        case isVisibleWhenNoStock = "is_visible_when_no_stock"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
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
    func responseOrderline(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Orderline>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
