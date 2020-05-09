//
//  NetworkConstants.swift
//  AppruveTest
//
//  Created by Fitzgerald Afful on 09/05/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkConstants {

    static let imageUploadURL = "https://stage.appruve.co/v1/verifications/test/file_upload"
    static let networkErrorMessage = "Please check your internet connection and try again."

    func getErrorMessage<T> (response: DataResponse<T, AFError>) -> String where T: Codable {
        var message = NetworkConstants.networkErrorMessage
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let error = json["errors"] as? NSDictionary {
                    if let myMessage = error["message"] as? String {
                        message = myMessage
                    }
                } else if let error = json["error"] as? NSDictionary {
                    if let message1 = error["message"] as? String {
                        message = message1
                    }
                } else if let messages = json["message"] as? String {
                    message = messages
                }
            }
        } else {
            print("Error Desc: \(response.error?.localizedDescription ?? "")")
            print("Error Code: \(response.error?.asAFError?.failureReason ?? "") \(response.response?.statusCode ?? 0)")
        }
        return message
    }
}

protocol APIConfiguration: URLRequestConvertible, URLConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var body: [String: Any] { get }
    var headers: HTTPHeaders { get }
    var parameters: [String: Any] { get }
}

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()
    func encode<T> (_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()
    func decode<T> (_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
