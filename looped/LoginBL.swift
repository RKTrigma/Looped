//
//  LoginBL.swift
//  Restaurant
//
//  Created by Divya Khanna on 9/26/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import Foundation
import UIKit

class LoginBL: BaseBL {
    
    func loginUser(_ onView: UIView, email: String, pwd: String , device_token: String){
        
        SVProgressHUD.show(withStatus: "Loading", maskType: .gradient)
        
        let urlComplement       = kLoginAPI
        var urlParameters       = [String:AnyObject]()
        var tempJson : NSString = ""
        let details             = ["email":"\(email)","password":"\(pwd)","device_token":"s6d54f5sd4f564sd65f465sd4f654sd6f54"] as [String : Any]
        
        do {
            let jsonData    = try JSONSerialization.data(withJSONObject: details, options: JSONSerialization.WritingOptions.prettyPrinted)
            tempJson        = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
        }catch let error as NSError{
            print(error.description)
        }
        
        urlParameters   = ["user_details":tempJson]
        let valid       = JSONSerialization.isValidJSONObject(urlParameters)
        print("Params : \(valid)")
        
        // Post data //
        DataManager.getData(urlParameters, urlComplement: urlComplement) { (retrieveData) in
            DispatchQueue.main.async() {
                SVProgressHUD.dismiss()

            }
            
            // Data received //
            if retrieveData != nil {
                do {
                    
                    let json : NSDictionary = try JSONSerialization.jsonObject(with: retrieveData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    if let result = json["status"]! as? Int {
                        
                        var dataTobePass = [String:AnyObject]()
                        let messageToPass = json["message"] as? String
                        
                        if result == 1 {
                            
                            DispatchQueue.main.async {
                                dataTobePass = ["status":1 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                if (UserDefaults.standard .value(forKey: "quickblox_id") != nil)
                                {
                                    UserDefaults.standard .removeObject(forKey: "quickblox_id")
                                    UserDefaults.standard .removeObject(forKey: "quickblox_pass")
                                    UserDefaults.standard .removeObject(forKey: "quickblox_username")
                                    
                                    UserDefaults.standard .removeObject(forKey: "user_id")
                                    
                                    UserDefaults.standard .synchronize()
                                }
                                
                                UserDefaults.standard .setValue(json["quickblox_id"], forKey: "quickblox_id")
                                UserDefaults.standard .setValue(json["quickblox_pass"], forKey: "quickblox_pass")
                                UserDefaults.standard .setValue(json["quickblox_username"], forKey: "quickblox_username")
                                
                                UserDefaults.standard .setValue(json["user_id"], forKey: "user_id")
                                
                                UserDefaults.standard .synchronize()
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                            
                            
                        }else{
                            // Pass data to controller.
                            DispatchQueue.main.async {
                                dataTobePass = ["status":101 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                        }
                    }
                    
                } catch {//Error in parsing
                    DispatchQueue.main.async {
                        // Invalid json
                        self.delegate.noDataReceived()
                    }
                }
            }
            else {//No data received
                DispatchQueue.main.async {
                    // Invalid data
                    self.delegate.noDataReceived()
                }
            }
        }//finish
    }
    
    
    //MARK:- Register
    
    func registerUser(_ onView: UIView, companyname: String, name: String, email: String, pwd: String, phonenumber: String, designation: String, confirmcountry: String){
        
        
        // Show Loading Indicator
        SVProgressHUD.show(withStatus: "Loading", maskType: .gradient)
        
        // Api
        let urlComplement = kRegister
        var urlParameters = [String:AnyObject]()
        var tempJson : NSString = ""
       
        let details = ["password":"\(pwd)","email":"\(email)","device_token":"s6d54f5sd4f564sd65f465sd4f654sd6f54","name":"\(name)","designation":"\(designation)","company":"\(companyname)","phone":"\(phonenumber)","country":"\(confirmcountry)"] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: details, options: JSONSerialization.WritingOptions.prettyPrinted)
            //print(jsonData)
            tempJson = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            //print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        urlParameters = ["user_details":tempJson]
        //print(urlParameters)
        let valid = JSONSerialization.isValidJSONObject(urlParameters)
        print("Params : \(valid)")
        
        // Post data
        DataManager.getData(urlParameters, urlComplement: urlComplement) { (retrieveData) in
            DispatchQueue.main.async() {
                // Hide Loading Indicator
                SVProgressHUD.dismiss()

            }
        
            // Data received
            if retrieveData != nil {
                do {
                    
                    let json : NSDictionary = try JSONSerialization.jsonObject(with: retrieveData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    if let result = json["status"]! as? Int {
                        
                        var dataTobePass = [String:AnyObject]()
                        let messageToPass = json["message"] as? String
                        
                        if result == 1 {
     
                            DispatchQueue.main.async {
                                dataTobePass = ["status":1 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                
                                
                                if (UserDefaults.standard .value(forKey: "quickblox_id") != nil)
                                {
                                    UserDefaults.standard .removeObject(forKey: "quickblox_id")
                                    UserDefaults.standard .removeObject(forKey: "quickblox_pass")
                                    UserDefaults.standard .removeObject(forKey: "quickblox_username")
                                    
                                    UserDefaults.standard .removeObject(forKey: "user_id")
                                    
                                    UserDefaults.standard .synchronize()
                                }
                                
                                UserDefaults.standard .setValue(json["quickblox_id"], forKey: "quickblox_id")
                                UserDefaults.standard .setValue(json["quickblox_pass"], forKey: "quickblox_pass")
                                UserDefaults.standard .setValue(json["quickblox_username"], forKey: "quickblox_username")
                                
                                UserDefaults.standard .setValue(json["user_id"], forKey: "user_id")
                                
                                UserDefaults.standard .synchronize()
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
 
                            
                        }else{
                            // Pass data to controller.
                            DispatchQueue.main.async {
                                dataTobePass = ["status":0 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                        }
                    }
                    
                } catch {//Error in parsing
                    
                    DispatchQueue.main.async {
                        // Invalid json
                        self.delegate.noDataReceived()
                    }
                }
            }
            else {//No data received
                DispatchQueue.main.async {
                    // Invalid data
                    self.delegate.noDataReceived()
                }
            }
        }//finish
    }
    
    
    // MARK: USER LIST API
    
    func userList(_ onView: UIView, userid: String){
        
        
        // Show Loading Indicator
        SVProgressHUD.show(withStatus: "Loading", maskType: .gradient)
        
        // Api
        let urlComplement = KUserList
        var urlParameters = [String:AnyObject]()
        var tempJson : NSString = ""
        
        let details = ["user_id":"\(userid)"] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: details, options: JSONSerialization.WritingOptions.prettyPrinted)
            //print(jsonData)
            tempJson = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            //print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        urlParameters = ["user_details":tempJson]
        //print(urlParameters)
        let valid = JSONSerialization.isValidJSONObject(urlParameters)
        print("Params : \(valid)")
        
        // Post data
        DataManager.getData(urlParameters, urlComplement: urlComplement) { (retrieveData) in
            DispatchQueue.main.async() {
                // Hide Loading Indicator
                SVProgressHUD.dismiss()

            }
            
            // Data received
            if retrieveData != nil {
                do {
                    
                    let json : NSDictionary = try JSONSerialization.jsonObject(with: retrieveData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    if let result = json["status"]! as? Int {
                        
                        var dataTobePass = [String:AnyObject]()
                        let messageToPass = json["message"] as? String
                        
                        if result == 1 {
                            
                            
                            if let resultArray = json["User"]! as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    
                                    dataTobePass = ["status":101 as AnyObject,"message" : messageToPass! as AnyObject , "data": resultArray]
                                    
                                    self.delegate.successResponseReceived(dataTobePass as AnyObject)
                                }
                            }
                        }else{
                            // Pass data to controller.
                            DispatchQueue.main.async {
                                dataTobePass = ["status":0 as AnyObject,"message" : messageToPass! as AnyObject]
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                        }
                    }
                    
                } catch {//Error in parsing
                    
                    DispatchQueue.main.async {
                        // Invalid json
                        self.delegate.noDataReceived()
                    }
                }
            }
            else {//No data received
                DispatchQueue.main.async {
                    // Invalid data
                    self.delegate.noDataReceived()
                }
            }
        }//finish
    }
    
    // MARK: ADD TO FAVOURITE
    
    func addToFavourite(_ onView: UIView, userid: String, favuser: String){
        
        // Show Loading Indicator
        SVProgressHUD.show(withStatus: "Loading", maskType: .gradient)
        
        // Api
        let urlComplement = KAddFavourite
        var urlParameters = [String:AnyObject]()
        var tempJson : NSString = ""
        //"password":"\(pwd)","email":"\(email)"
        let details = ["user_id":"\(userid)","fav_user":"\(favuser)"] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: details, options: JSONSerialization.WritingOptions.prettyPrinted)
            //print(jsonData)
            tempJson = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            //print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        urlParameters = ["user_details":tempJson]
        //print(urlParameters)
        let valid = JSONSerialization.isValidJSONObject(urlParameters)
        print("Params : \(valid)")
        
        // Post data
        DataManager.getData(urlParameters, urlComplement: urlComplement) { (retrieveData) in
            DispatchQueue.main.async() {
                // Hide Loading Indicator
                SVProgressHUD.dismiss()

            }
            
            // Data received
            if retrieveData != nil {
                do {
                    
                    let json : NSDictionary = try JSONSerialization.jsonObject(with: retrieveData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    
                    if let result = json.value(forKey: "status")! as? String {
                        
                        var dataTobePass = [String:AnyObject]()
                        let messageToPass = json["message"] as? String
                        
                        if result == "1" {
                            
                           // if let resultArray = json["User"]! as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    dataTobePass = ["status":123 as AnyObject,"message" : messageToPass! as AnyObject]
                                    
                                    self.delegate.successResponseReceived(dataTobePass as AnyObject)
                                }
                           // }
                            
                        }else{
                            // Pass data to controller.
                            DispatchQueue.main.async {
                                dataTobePass = ["status":111 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                        }
                    }
                    
                } catch {//Error in parsing
                    
                    DispatchQueue.main.async {
                        // Invalid json
                        self.delegate.noDataReceived()
                    }
                }
            }
            else {//No data received
                DispatchQueue.main.async {
                    // Invalid data
                    self.delegate.noDataReceived()
                }
            }
        }//finish
    }

    
    // MARK: favouriteList LIST API
    
    func favouriteList(_ onView: UIView, userid: String){
        
        // Show Loading Indicator
        SVProgressHUD.show(withStatus: "Loading", maskType: .gradient)
        
        // Api
        let urlComplement = KFavList
        var urlParameters = [String:AnyObject]()
        var tempJson : NSString = ""
        
        let details = ["user_id":"\(userid)"] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: details, options: JSONSerialization.WritingOptions.prettyPrinted)
            //print(jsonData)
            tempJson = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            //print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        urlParameters = ["user_details":tempJson]
        //print(urlParameters)
        let valid = JSONSerialization.isValidJSONObject(urlParameters)
        print("Params : \(valid)")
        
        // Post data
        DataManager.getData(urlParameters, urlComplement: urlComplement) { (retrieveData) in
            DispatchQueue.main.async() {
                // Hide Loading Indicator
                SVProgressHUD.dismiss()

            }
            
            // Data received
            if retrieveData != nil {
                do {
                    
                    let json : NSDictionary = try JSONSerialization.jsonObject(with: retrieveData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    if let result = json["status"]! as? Int {
                        
                        var dataTobePass = [String:AnyObject]()
                        let messageToPass = json["message"] as? String
                        
                        if result == 1 {
                            
                            if let resultArray = json["User"]! as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    dataTobePass = ["status":101 as AnyObject,"message" : messageToPass! as AnyObject , "data": resultArray]
                                    
                                    self.delegate.successResponseReceived(dataTobePass as AnyObject)
                                }
                            }
                            
                        }else{
                            // Pass data to controller.
                            DispatchQueue.main.async {
                                dataTobePass = ["status":102 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                        }
                    }
                    
                } catch {//Error in parsing
                    
                    DispatchQueue.main.async {
                        // Invalid json
                        self.delegate.noDataReceived()
                    }
                }
            }
            else {//No data received
                DispatchQueue.main.async {
                    // Invalid data
                    self.delegate.noDataReceived()
                }
            }
        }//finish
    }
    
    
    // MARK: DELETE FAVOURITE USER
    
    func delFavouriteUser(_ onView: UIView, userid: String, favuser: String){
        
        // Show Loading Indicator
        
        SVProgressHUD.show(withStatus: "Loading", maskType: .gradient)
        
        // Api
        let urlComplement = KDeleteFav
        var urlParameters = [String:AnyObject]()
        var tempJson : NSString = ""
        //"password":"\(pwd)","email":"\(email)"
        let details = ["user_id":"\(userid)","fav_id":"\(favuser)"] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: details, options: JSONSerialization.WritingOptions.prettyPrinted)
            //print(jsonData)
            tempJson = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            //print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        urlParameters = ["user_details":tempJson]
        //print(urlParameters)
        let valid = JSONSerialization.isValidJSONObject(urlParameters)
        print("Params : \(valid)")
        
        // Post data
        DataManager.getData(urlParameters, urlComplement: urlComplement) { (retrieveData) in
            DispatchQueue.main.async() {
                // Hide Loading Indicator
                SVProgressHUD.dismiss()
            }
            
            // Data received
            if retrieveData != nil {
                do {
                    
                    let json : NSDictionary = try JSONSerialization.jsonObject(with: retrieveData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    if let result = json.value(forKey: "status")! as? String {
                        
                        var dataTobePass = [String:AnyObject]()
                        let messageToPass = json["message"] as? String
                        
                        if result == "1" {
                            
                            // if let resultArray = json["User"]! as? NSArray {
                            DispatchQueue.main.async {
                                
                                dataTobePass = ["status":103 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                            // }
                            
                        }else{
                            // Pass data to controller.
                            DispatchQueue.main.async {
                                dataTobePass = ["status":104 as AnyObject,"message" : messageToPass! as AnyObject]
                                
                                self.delegate.successResponseReceived(dataTobePass as AnyObject)
                            }
                        }
                    }
                    
                } catch {//Error in parsing
                    
                    DispatchQueue.main.async {
                        // Invalid json
                        self.delegate.noDataReceived()
                    }
                }
            }
            else {//No data received
                DispatchQueue.main.async {
                    // Invalid data
                    self.delegate.noDataReceived()
                }
            }
        }//finish
    }
    
}

