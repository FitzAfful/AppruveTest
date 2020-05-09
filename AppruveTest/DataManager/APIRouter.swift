//
//  APIRouter.swift
//  AppruveTest
//
//  Created by Fitzgerald Afful on 09/05/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Alamofire

enum Router: APIConfiguration, URLConvertible {

    case imageUpload (userId: String)

    internal var method: HTTPMethod {
        switch self {
        case .imageUpload:
            return .post
        }
    }

    internal var path: String {
        switch self {
        case .imageUpload:
            return NetworkConstants.imageUploadURL
        }
    }

    internal var parameters: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }

    internal var body: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }

    internal var headers: HTTPHeaders {
        switch self {
        default:
            return ["Content-Type": "application/json", "Accept": "application/json"]
        }
    }

    func asURL () throws -> URL {
        var urlComponents: URLComponents!
        urlComponents = URLComponents(string: path)!
        var queryItems: [URLQueryItem] = []
        for item in parameters {
            queryItems.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        if !(queryItems.isEmpty) {
            urlComponents.queryItems = queryItems
            print("Query Items: \(queryItems)")
            print(parameters)
        }
        let url = urlComponents.url!
        return url
    }

    func asURLRequest () throws -> URLRequest {
        var urlComponents: URLComponents! = URLComponents(string: path)!
        var queryItems: [URLQueryItem] = []
        for item in parameters {
            queryItems.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        if !(queryItems.isEmpty) {
            urlComponents.queryItems = queryItems
            print("Query Items: \(queryItems)")
            print(parameters)
        }
        let url = urlComponents.url!
        print("Full URL: \(method.rawValue) \(url)")
        print("Body: \(body)")
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.dictionary

        if !(body.isEmpty) {
            urlRequest = try URLEncoding().encode(urlRequest, with: body)

            let jsonData1 = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            urlRequest.httpBody = jsonData1
        }

        return urlRequest

    }
}
