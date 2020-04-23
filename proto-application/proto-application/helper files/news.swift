//
//  news.swift
//  proto-application
//
//  Created by Hessel Bierma on 30/03/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let news = try? newJSONDecoder().decode(News.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseNews { response in
//     if let news = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

typealias News = [NewsElement]

struct NewsElement: Codable {
    let id: Int?
    let title: String?
    let featuredImageURL: String?
    let content: String?
    let publishedAt: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case featuredImageURL = "featured_image_url"
        case content
        case publishedAt = "published_at"
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
    func responseNews(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<News>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
