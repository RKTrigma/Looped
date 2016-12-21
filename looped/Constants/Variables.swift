//
//  Variables.swift
//  Qperz
//
//  Created by Arshdeep Kaur on 28/12/15.
//  Copyright © 2015 Alchemist Infosystems. All rights reserved.
//

import Foundation

class Variables {
    class var sharedVariables : Variables {
        struct Static {
            static let instance : Variables = Variables()
        }
        return Static.instance
    }
    
    // MARK: - Current session task
    var currentTask: URLSessionTask?
    
    // MARK: - Device Token
    var deviceToken: String = ""
    
    // MARK: - Current center screen
    var centerScreen: String = ""
}
