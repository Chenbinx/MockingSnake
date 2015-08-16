//
//  NSURLSessionConfiguration.swift
//  MockingSnake
//
//  Created by Bin Chen on 15/8/16.
//  Copyright © 2015年 Bin Chen. All rights reserved.
//

import Foundation


extension NSURLSessionConfiguration {
    override public class func initialize() {
        if (self === NSURLSessionConfiguration.self) {
            let defaultSessionConfiguration = class_getClassMethod(self, "defaultSessionConfiguration")
            let snakeDefaultSessionConfiguration = class_getClassMethod(self, "snakeDefaultSessionConfiguration")
            method_exchangeImplementations(defaultSessionConfiguration, snakeDefaultSessionConfiguration)
            
            let ephemeralSessionConfiguration = class_getClassMethod(self, "ephemeralSessionConfiguration")
            let snakeEphemeralSessionConfiguration = class_getClassMethod(self, "snakeEphemeralSessionConfiguration")
            method_exchangeImplementations(ephemeralSessionConfiguration, snakeEphemeralSessionConfiguration)
        }
    }
    
    class func snakeDefaultSessionConfiguration() -> NSURLSessionConfiguration {
        let configuration = snakeDefaultSessionConfiguration()
        configuration.protocolClasses = [SnakeProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
    
    class func snakeEphemeralSessionConfiguration() -> NSURLSessionConfiguration {
        let configuration = snakeEphemeralSessionConfiguration()
        configuration.protocolClasses = [SnakeProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
}