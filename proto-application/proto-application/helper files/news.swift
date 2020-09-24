//
//  News.swift
//  probeersel
//
//  Created by Hessel Bierma on 18-04-2020.
//  Copyright © 2020 Hessel Bierma. All rights reserved.
//

import Foundation
import CoreData

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsArticles = try? newJSONDecoder().decode(NewsArticles.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.newsArticlesTask(with: url) { newsArticle, response, error in
//     if let newsArticle = newsArticle {
//       ...
//     }
//   }
//   task.resume()


//class articleImgs {
//
//    func fetch(moc : NSManagedObjectContext, news : Fetched) {
//        let url : NSURL = NSURL(string: "")!
//        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "News")
//        let predicate = NSPredicate(format: "'featuredImgUrl' != %@", url)
//        fetchReq.predicate = predicate
//
//        do {
//            let results = try moc.fetch(fetchReq)
//
//            for result in results{
//                if
//            }
//
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//
//    }
//}


// MARK: - NewsArticle
struct NewsArticle: Codable {
    let id: Int
    let title: String
    let featuredImageURL: String?
    let content: String
    let publishedAt: Double

    enum CodingKeys: String, CodingKey {
        case id, title
        case featuredImageURL = "featured_image_url"
        case content
        case publishedAt = "published_at"
    }
}

typealias NewsArticles = [NewsArticle]


// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func newsArticlesTask(with url: URL, completionHandler: @escaping (NewsArticles?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
