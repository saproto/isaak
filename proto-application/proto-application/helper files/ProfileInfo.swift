//
//  ProfileInfo.swift
//  proto-application
//
//  Created by Hessel Bierma on 12/12/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import Foundation
import Alamofire

struct ProfileInfo: Codable {
    let id: Int?
    let name, callingName, email, birthdate: String?
    let phone, website: String?
    let phoneVisible, addressVisible, receiveSMS, keepProtubeHistory: Int?
    let showBirthday, showAchievements, showOmnomcomTotal, keepOmnomcomHistory: Int?
    let prefCalendarAlarm, prefCalendarRelevantOnly: Int?
    let utwenteUsername, eduUsername, utwenteDepartment: String?
    let didStudyCreate, didStudyItech, signedNda: Int?
    let isMember: Bool?
    let photoPreview: String?
    let welcomeMessage: String?
    let member: Member?
    let photo: Photo?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case callingName = "calling_name"
        case email, birthdate, phone, website
        case phoneVisible = "phone_visible"
        case addressVisible = "address_visible"
        case receiveSMS = "receive_sms"
        case keepProtubeHistory = "keep_protube_history"
        case showBirthday = "show_birthday"
        case showAchievements = "show_achievements"
        case showOmnomcomTotal = "show_omnomcom_total"
        case keepOmnomcomHistory = "keep_omnomcom_history"
        case prefCalendarAlarm = "pref_calendar_alarm"
        case prefCalendarRelevantOnly = "pref_calendar_relevant_only"
        case utwenteUsername = "utwente_username"
        case eduUsername = "edu_username"
        case utwenteDepartment = "utwente_department"
        case didStudyCreate = "did_study_create"
        case didStudyItech = "did_study_itech"
        case signedNda = "signed_nda"
        case isMember = "is_member"
        case photoPreview = "photo_preview"
        case welcomeMessage = "welcome_message"
        case member, photo
    }
}

struct Member: Codable {
    let id, userID: Int?
    let protoUsername, createdAt, updatedAt: String?
    let isLifelong, isHonorary, isDonator: Int?
    let deletedAt, cardPrintedOn: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case protoUsername = "proto_username"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isLifelong = "is_lifelong"
        case isHonorary = "is_honorary"
        case isDonator = "is_donator"
        case deletedAt = "deleted_at"
        case cardPrintedOn = "card_printed_on"
    }
}

struct Photo: Codable {
    let id: Int?
    let filename, mime, originalFilename, createdAt: String?
    let updatedAt, hash: String?
    
    enum CodingKeys: String, CodingKey {
        case id, filename, mime
        case originalFilename = "original_filename"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case hash
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
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
    func responseProfileInfo(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ProfileInfo>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
