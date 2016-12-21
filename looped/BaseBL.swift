//
//  BaseBL.swift
// Restaurant
//
//  Created by Divya Khanna on 9/23/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import Foundation

@objc protocol BaseBLDelegate {
    func successResponseReceived (_ response:AnyObject)
    func failureResponseReceived (_ response:AnyObject)
    func noDataReceived ()
    
    @objc optional func otherStatusReceived (_ response:AnyObject)
    @objc optional func unansweredStatusReceived (_ response:AnyObject)
}

class BaseBL: NSObject {
    var delegate:BaseBLDelegate! = nil
}

