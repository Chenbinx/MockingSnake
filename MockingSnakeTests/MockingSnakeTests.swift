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

func everything(request: NSURLRequest) -> Bool {
    return true
}


class MockingSnakeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStub() {
        let expect = expectationWithDescription("expect mocking...")
        let stub = Stub(matcher: everything, builder: builder)
        SnakeProtocol.addStub(stub)
        
        Snake.get("www.baidu.com", params: ["phone": "13594171983"], callback: { (data, response, error) -> Void in
            print("hello response: \(response.statusCode)")
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
