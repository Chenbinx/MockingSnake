//
//  Builder.swift
//  MockingSnake
//
//  Created by Bin Chen on 15/8/16.
//  Copyright © 2015年 Bin Chen. All rights reserved.
//

import Foundation

func builder(request: NSURLRequest) -> Response {
    let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 201, HTTPVersion: nil, headerFields: nil)!
    let data:NSData? = nil
    return .Success(response, data)
}

public func http(status: Int = 200, header: [String: String]? = nil, data: NSData? = nil)(request: NSURLRequest) -> Response {
    let response = NSHTTPURLResponse(URL: request.URL!, statusCode: status, HTTPVersion: nil, headerFields: header)
    return Response.Success(response!, data)
}

public func json(status: Int = 200, header: [String: String]? = nil, body: AnyObject)(request: NSURLRequest) -> Response {
    let data = try!(NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions()))
    var header = header ?? [String: String]()
    if header["Content-Type"] == nil {
        header["Content-Type"] = "application/json; charset=utf-8"
    }
    return http(status, header: header, data: data)(request: request)
}