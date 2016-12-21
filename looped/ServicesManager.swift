//
//  ServicesManager.swift
//  looped
//
//  Created by Raman Kant on 12/19/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

protocol ServicesManagerDelegate {
    
    func successResponseReceived (_ response:AnyObject)
    func failureResponseReceived (_ response:AnyObject)
    func nilReponseReceived ()
    func timeOut ()
    func networkError ()
}

class ServicesManager: NSObject {
    
    var delegate:ServicesManagerDelegate!   = nil
    let BASE_URL                            = "http://dev414.trigma.us/Looped/Webservices/"
    
    func logInUser(userCredentials: NSMutableDictionary, completion: @escaping (_ result: NSDictionary? , _ error : NSError? ) -> Void) {
        
        var parameters: String                      = ""
        for (key, value) in userCredentials{
            if(parameters.isEmpty){ parameters      = parameters+"\(key)"+"=\(value)" }
            else{ parameters                        = parameters+"&\(key)"+"=\(value)" }
        }
        parameters                          = parameters.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let urlString: String               = BASE_URL + "login"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.setValue("\(UInt(parameters.lengthOfBytes(using: String.Encoding.utf8)))", forHTTPHeaderField: "Content-Length")
        request.httpBody                    = parameters.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                    print(jsonDict)
                    completion(jsonDict , nil)
                }
            } catch let error as NSError {
                print(error)
                completion(nil , error)
            }
        }
        task.resume()
        return
    }
    
    func registerUser(userCredentials: NSMutableDictionary, completion: @escaping (_ result: AnyObject , _ error : NSError? ) -> Void) {
        
        var parameters: String                      = ""
        for (key, value) in userCredentials{
            if(parameters.isEmpty){ parameters      = parameters+"\(key)"+"=\(value)" }
            else{ parameters                        = parameters+"&\(key)"+"=\(value)" }
        }
        parameters                          = parameters.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let urlString: String               = BASE_URL + "registeruser"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.setValue("\(UInt(parameters.lengthOfBytes(using: String.Encoding.utf8)))", forHTTPHeaderField: "Content-Length")
        request.httpBody                    = parameters.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
           
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                    print(jsonDict)
                    completion(jsonDict , error as NSError?)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
        return
    }
    
   
}
