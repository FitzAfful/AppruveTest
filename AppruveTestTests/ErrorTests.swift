//
//  ErrorTests.swift
//  AppruveTestTests
//
//  Created by Fitzgerald Afful on 09/05/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//


import XCTest
@testable import Alamofire
@testable import Mocker
@testable import AppruveTest

class VideoItemTests: XCTestCase {

    var bundle: Bundle!

    override func setUpWithError() throws {
        bundle = Bundle(for: VideoItemTests.self)
    }

    func testErrorJSONMapping() throws {
        guard let url = bundle.url(forResource: "errorResponse", withExtension: "json") else {
            XCTFail("Missing file: errorResponse.json")
            return
        }

        let json = try Data(contentsOf: url)
        let item = try! JSONDecoder().decode(ErrorBody.self, from: json)

        XCTAssertEqual(item.message, "Validation Failed")
        XCTAssertEqual(item.code, 3)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
