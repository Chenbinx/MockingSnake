//
//  MockingSnake.swift
//  MockingSnake
//
//  Created by Bin Chen on 15/8/11.
//  Copyright © 2015年 Bin Chen. All rights reserved.
//

import Foundation


public enum Response : Equatable {
    case Success(NSURLResponse, NSData?)
    case Failure(NSError)
}

public func ==(lhs: Response, rhs: Response) -> Bool {
    switch (lhs, rhs) {
    case let (.Failure(lhsError), .Failure(rhsError)):
        return lhsError == rhsError
    case let (.Success(lhsResponse, lhsData), .Success(rhsResponse, rhsData)):
        return lhsResponse == rhsResponse && lhsData == rhsData
    default:
        return false
    }
}

public typealias Matcher = (NSURLRequest) -> Bool
public typealias Builder = (NSURLRequest) -> Response
