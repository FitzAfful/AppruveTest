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
    static let userIdKey = "user_id"
    static let documentKey = "document"

    func getErrorMessage<T>(response: DataResponse<T, AFError>) -> String where T: Codable {
        var message = NetworkConstants.networkErrorMessage
        if let data = response.data {
            if let error = try? JSONDecoder().decode(ErrorBody.self, from: data) {
                message = error.details[0].field + " " + error.details[0].code
            }
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

struct APIResponse: Any, Codable {

}

struct ErrorBody: Codable {
    let code: Int
    let message: String
    let details: [ErrorBodyDetail]
}

struct ErrorBodyDetail: Codable {
    let resource: String
    let field: String
    let code: String
}
