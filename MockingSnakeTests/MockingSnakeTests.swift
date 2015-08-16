//
//  MockingSnakeTests.swift
//  MockingSnakeTests
//
//  Created by Bin Chen on 15/8/9.
//  Copyright © 2015年 Bin Chen. All rights reserved.
//

import XCTest
@testable import MockingSnake

func builder(request: NSURLRequest) -> Response {
    let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 201, HTTPVersion: nil, headerFields: nil)!
    let data:NSData? = nil
    return .Success(response, data)
}

func toString(p: AnyClass) -> String {
    return "\(p)"
}

class MockingSnakeTests: XCTestCase {
    
    func testEphemeralSessionConfigurationIncludesProtocol() {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let protocolClasses = config.protocolClasses!.map(toString)
        XCTAssertEqual(protocolClasses.first!, "SnakeProtocol")
    }
    
    func testDefaultSessionConfigurationIncludesProtocol() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let protocolClasses = config.protocolClasses!.map(toString)
        XCTAssertEqual(protocolClasses.first!, "SnakeProtocol")
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        removeAllSnakeMockingStub()
    }
    
    func testStub() {
        let expect = expectationWithDescription("expect mocking...")
        addSnakeMockingStub(everything, builder: json(body: ["name": "chenbin", "age": 10]))

        Snake.get("www.baidu.com", params: ["phone": "13594171983"], callback: { (data, response, error) -> Void in
            print("hello response: \(response.statusCode)")
            var json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            json = json as! [String: AnyObject]
            XCTAssertEqual(json["name"], "chenbin")
            XCTAssertEqual(json["age"], 10)
            expect.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            if error != nil {
                XCTFail("error: \(error)")
            }
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
