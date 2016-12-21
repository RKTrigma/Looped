//
//  Constants.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 3/30/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//


import Foundation

let kChatPresenceTimeInterval:TimeInterval = 45
let kDialogsPageLimit:UInt = 100
let kMessageContainerWidthPadding:CGFloat = 40.0

let appUrl        = "http://dev414.trigma.us/Looped/Webs/"

let kLoginAPI     = "login"
let kRegister     = "registeruser"
let KUserList     = "userlist"
let KAddFavourite = "add_favourite"
let KFavList      = "favourite_list"
let KDeleteFav    = "delete_favourite_list"

// Common Strings - Alerts
let internetNotAvailableTitle = "Internet Not Available"
let internetNotAvailableMsg = "Please check your internet connection."
let noDataAvailableTitle = "No Data Available"
let pleaseTryAgainMsg = "Please try again."

// Common Strings - Loading Indicator
let loading = "Please Wait"


class Constants {
    class var QB_USERS_ENVIROMENT: String {
        #if DEBUG
            return "dev"
        #elseif QA
            return "qbqa"
        #else
            assert(false, "Not supported build configuration")
            return ""
        #endif
    }
}
