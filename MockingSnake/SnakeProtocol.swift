//
//  SnakeProtocol.swift
//  MockingSnake
//
//  Created by Bin Chen on 15/8/10.
//  Copyright © 2015年 Bin Chen. All rights reserved.
//

import Foundation

public struct Stub: Equatable {
    let matcher: Matcher
    let builder: Builder
    let uuid: NSUUID
    
    public init(matcher: Matcher, builder: Builder) {
        self.matcher = matcher
        self.builder = builder
        self.uuid = NSUUID()
    }
}

public func ==(lhs: Stub, rhs: Stub) -> Bool {
    return lhs.uuid == rhs.uuid
}

var stubs = [Stub]()

public class SnakeProtocol: NSURLProtocol {
    public class func addStub(stub: Stub) -> Stub {
        stubs.append(stub)
        
        var token: dispatch_once_t = 0
        dispatch_once(&token) {
            NSURLProtocol.registerClass(self)
            return
        }
        
        return stub
    }
    
    public class func addStub(matcher: Matcher, builder: Builder) -> Stub {
        return addStub(Stub(matcher: matcher, builder: builder))
    }
    
    public class func removeStub(stub: Stub) {
        if let index = stubs.indexOf(stub) {
            stubs.removeAtIndex(index)
        }
    }
    
    public class func removeAllStubs() {
        stubs.removeAll()
    }

    public class func stubForRequest(request: NSURLRequest) -> Stub? {
        for stub in stubs {
            if stub.matcher(request) {
                return stub
            }
        }
        return nil
    }
    
    override public class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return stubForRequest(request) != nil
    }
    
    override public class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override public class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, toRequest: bRequest)
    }
    
    override public func startLoading() {
        if let stub = SnakeProtocol.stubForRequest(request) {
            switch stub.builder(request) {
            case .Failure(let error):
                client?.URLProtocol(self, didFailWithError: error)
            case .Success(let response, let data):
                client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
                
                if let data = data {
                    client?.URLProtocol(self, didLoadData: data)
                }
                client?.URLProtocolDidFinishLoading(self)
            }
        } else {
            let error = NSError(domain: NSInternalInconsistencyException, code: 0, userInfo: [ NSLocalizedDescriptionKey: "Handling request without a matching stub." ])
            client?.URLProtocol(self, didFailWithError: error)
        }
    }
    
    override public func stopLoading() {
        
    }
}

public func addSnakeMockingStub(matcher: Matcher, builder: Builder) -> Stub {
    return SnakeProtocol.addStub(Stub(matcher: matcher, builder: builder))
}

public func removeSnakeMockingStub(stub: Stub) {
    SnakeProtocol.removeStub(stub)
}

public func removeAllSnakeMockingStub() {
    SnakeProtocol.removeAllStubs()
}







