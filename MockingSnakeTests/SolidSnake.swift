//
//  SolidSnake.swift
//  SolidSnake
//
//  Created by Bin Chen on 15/6/7.
//  Copyright (c) 2015年 Bin Chen. All rights reserved.
//

import Foundation

class SessionDelegate: NSObject, NSURLSessionDelegate {
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        let protectSpace = challenge.protectionSpace
        if (protectSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let serverTrust = protectSpace.serverTrust
            completionHandler(.UseCredential, NSURLCredential(trust: serverTrust!))
        } else {
            completionHandler(.PerformDefaultHandling, nil)
        }
    }
}

class SolidSnake: NSObject, NSURLSessionDelegate {
    
    let method: String
    let params: [String: AnyObject]
    let callback: (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void

    let url: String
    var task: NSURLSessionTask!
    var request: NSMutableURLRequest!

    let session: NSURLSession!

    let queue = NSOperationQueue()
    let defaultConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    init(url: String, method: String, params: [String: AnyObject] = [String: AnyObject](), callback: (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void) {
        self.url = url
        self.method = method
        self.params = params
        self.callback = callback
        self.session = NSURLSession(configuration: self.defaultConfig, delegate: SessionDelegate(), delegateQueue: self.queue)
    }
    
    func buildRequest() {
        if method == "GET" && params.count > 0 {
            self.request = NSMutableURLRequest(URL: NSURL(string: url + "?" + buildParams(self.params))!)
        }
        self.request.HTTPMethod = self.method
        if self.params.count > 0 {
            self.request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
    
    func doRequestTask() {
        self.task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            self.callback(data: data, response: response as! NSHTTPURLResponse, error: error)
        })
        self.task.resume()
    }
    
    func doRequest() {
        self.buildRequest()
        self.doRequestTask()
    }
    
    // Get from Alamofire
    func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return "&".join(components.map{"\($0)=\($1)"} as [String])
    }
    
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.extend([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: NSCharacterSet = NSCharacterSet(charactersInString: ":&=;+!@#$()',*")
        return string.stringByAddingPercentEncodingWithAllowedCharacters(legalURLCharactersToBeEscaped)!
    }
}

class Snake {
    static func get(url: String, params: [String: AnyObject], callback: (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void) {
        let ss = SolidSnake(url: url, method: "GET", params: params, callback: callback)
        ss.doRequest()
    }
}











