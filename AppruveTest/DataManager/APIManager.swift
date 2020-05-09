//
//  APIManager.swift
//  AppruveTest
//
//  Created by Fitzgerald Afful on 09/05/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Alamofire

typealias ImageUploadCompletionHandler = (_ videoResponse: Result<String, AFError>) -> Void

protocol DataManagerProtocol {
    func uploadImage(_ data: Data, userId: String, completionHandler: @escaping ImageUploadCompletionHandler) throws
}

public class APIManager: NSObject, DataManagerProtocol {
    static let shared: DataManagerProtocol = APIManager()
    private var manager: Session = Session.default

    init(manager: Session = Session.default) {
        super.init()
        self.manager = manager
    }

    func uploadImage(_ data: Data, userId: String, completionHandler: @escaping ImageUploadCompletionHandler) {
        let router = APIRouter.imageUpload(userId: userId)
        manager.upload(multipartFormData: {  (multipartFormData) in
            multipartFormData.append(data, withName: NetworkConstants.documentKey, fileName: "swift_file \(arc4random_uniform(100)).jpg", mimeType: "image/jpeg")
            multipartFormData.append(userId.data(using: String.Encoding.utf8)!, withName: NetworkConstants.userIdKey)
        }, to: router).responseDecodable {(response) in
            completionHandler(response.result)
        }
    }
}
