//
//  DataManager.swift
// Restaurant
//
//  Created by Divya Khanna on 9/23/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//


import Foundation

class DataManager {
    
    class func getDataFromUrl(_ url: String,success: @escaping ((_ retrieveData: NSData?) -> Void)){
        //create the full url to retrieve data
        loadDataFromURL(URL(string: url)!, completion:{(data, error) -> Void in
            
            if let urlData = data {
                //retrieve when i get some data from server error success or something else
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: urlData as Data, options: []) as? NSDictionary {
                        CommonFunctions.sharedCommonFunctions.CustomLog("\(jsonDict)")
                        success(urlData)
                    }
                } catch let error as NSError {
                    CommonFunctions.sharedCommonFunctions.CustomLog("\(error)")
                    success(nil)
                }
            }else{
                //retrieve when is imposible connect to the service
                success(nil)
            }
        })
    }
    
    //for call this function we need to pass the url parameters in a dictionary variable (key,value) and the url complement without final /
    class func getData(_ urlParameter: [String: AnyObject], urlComplement: String,success: @escaping ((_ retrieveData: NSData?) -> Void)){
        
        // urlForRequest = urlForRequest.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        var parameters: String = ""
        for (key, value) in urlParameter{
            
            if(parameters.isEmpty)
            {
                
                parameters = parameters+"?\(key)"+"=\(value)"
                
            }
            else
            {
                parameters = parameters+"&\(key)"+"=\(value)"
            }
        }
        parameters = parameters.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        //parameters = parameters.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        var globalUrl = ""
        globalUrl = appUrl
        
        CommonFunctions.sharedCommonFunctions.CustomLog("url:\(globalUrl + urlComplement + parameters)")
        
        //create the full url to retrieve data
        loadDataFromURL(URL(string: globalUrl+urlComplement+parameters)!, completion:{(data, error) -> Void in
            
            if let urlData = data {
                //retrieve when i get some data from server error success or something else
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: urlData as Data, options: []) as? NSDictionary {
                        CommonFunctions.sharedCommonFunctions.CustomLog("\(jsonDict)")
                        success(urlData)
                    }
                } catch let error as NSError {
                    CommonFunctions.sharedCommonFunctions.CustomLog("\(error)")
                    success(nil)
                }
            }else{
                //retrieve when is imposible connect to the service
                success(nil)
            }
        })
        
    }
    class func getDataWithoutParams(_ urlComplement: String,success: @escaping ((_ retrieveData: NSData?) -> Void)){
        CommonFunctions.sharedCommonFunctions.CustomLog("url: "+urlComplement)
        
        // let urlComplement = urlComplement.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        //create the full url to retrieve data
        /* loadDataFromURL(url: NSURL(string: appUrl+urlComplement)!, completion:{(data, error) -> Void in
         
         if let urlData = data {
         //retrieve when i get some data from server error success or something else
         do {
         if let jsonDict = try NSJSONSerialization.JSONObjectWithData(urlData, options: []) as? NSDictionary {
         CommonFunctions.sharedCommonFunctions.CustomLog("\(jsonDict)")
         success(retrieveData: urlData)
         }
         } catch let error as NSError {
         CommonFunctions.sharedCommonFunctions.CustomLog("\(error)")
         success(retrieveData: nil)
         }
         }else{
         //retrieve when is imposible connect to the service
         success(retrieveData: nil)
         }
         })*/
        
    }
    
    class func postOrPutData(_ urlParameter: [String: String],httpMethod: String, urlComplement: String,success: @escaping ((_ retrieveData: NSData?) -> Void)){
        
        CommonFunctions.sharedCommonFunctions.CustomLog("url: "+appUrl+urlComplement)
        CommonFunctions.sharedCommonFunctions.CustomLog("param: \(urlParameter)")
        
        loadDataFromURLPostOrPut(urlParameter,httpMethod:httpMethod,url: URL(string: appUrl+urlComplement)!, completion:{(data, error) -> Void in
            
            if let urlData = data {
                //retrieve when i get some data from server error success or something else
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: urlData as Data, options: []) as? NSDictionary {
                        CommonFunctions.sharedCommonFunctions.CustomLog("\(jsonDict)")
                        success(urlData)
                    }
                } catch let error as NSError {
                    CommonFunctions.sharedCommonFunctions.CustomLog("\(error)")
                    success(nil)
                }
            }
            else
            {
                success(nil)
            }
        })
        
    }
    class func postData(_ urlParameter: [String: AnyObject],httpMethod: String, urlComplement: String,success: @escaping ((_ retrieveData: NSData?) -> Void)){
        
        CommonFunctions.sharedCommonFunctions.CustomLog("url: "+appUrl+urlComplement)
        CommonFunctions.sharedCommonFunctions.CustomLog("param: \(urlParameter)")
        
        loadDataFromURLPost(urlParameter,httpMethod:httpMethod,url: URL(string: appUrl+urlComplement)!, completion:{(data, error) -> Void in
            
            if let urlData = data {
                //retrieve when i get some data from server error success or something else
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: urlData as Data, options: []) as? NSDictionary {
                        CommonFunctions.sharedCommonFunctions.CustomLog("\(jsonDict)")
                        success(urlData)
                    }
                } catch let error as NSError {
                    CommonFunctions.sharedCommonFunctions.CustomLog("\(error)")
                    success(nil)
                }
            }
            else
            {
                success(nil)
            }
        })
        
    }
    class func deleteData(_ urlParameter: [String: String], urlComplement: String,success: @escaping ((_ retrieveData: NSData?) -> Void)){
        
        //urlForRequest = urlForRequest.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        var parameters: String = ""
        for (key, value) in urlParameter{
            parameters = parameters+"/\(key)"+"/\(value)"
        }
        CommonFunctions.sharedCommonFunctions.CustomLog("url: "+appUrl+urlComplement+parameters)
        let strUrl = appUrl+urlComplement+parameters
        CommonFunctions.sharedCommonFunctions.CustomLog("strUrl: "+strUrl)
        
        if let url: URL = URL(string: strUrl) as URL? {
            CommonFunctions.sharedCommonFunctions.CustomLog("url: \(url)")
            
        }
        else {
            CommonFunctions.sharedCommonFunctions.CustomLog("Invalid url")
        }
        
        //create the full url to retrieve data
        loadDataFromURLDelete(URL(string: strUrl)!, completion:{(data, error) -> Void in
            
            if let urlData = data {
                //retrieve when i get some data from server error success or something else
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: urlData as Data, options: []) as? NSDictionary {
                        CommonFunctions.sharedCommonFunctions.CustomLog("\(jsonDict)")
                        success(urlData)
                    }
                } catch let error as NSError {
                    CommonFunctions.sharedCommonFunctions.CustomLog("\(error)")
                    success(nil)
                }
            }else{
                //retrieve when is imposible connect to the service
                success(nil)
            }
        })
        
    }
    
    class func deleteDataRaw(_ urlParameter: String, urlComplement: String,success: @escaping ((_ retrieveData: NSData?) -> Void)){
        CommonFunctions.sharedCommonFunctions.CustomLog("url: "+appUrl+urlComplement)
        //create the full url to retrieve data
        loadDataFromURLRawDelete(urlParameter, url: URL(string: appUrl+urlComplement)!, completion: { (data, error) -> Void in
            if let urlData = data {
                //retrieve when i get some data from server error success or something else
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: urlData as Data, options: []) as? NSDictionary {
                        CommonFunctions.sharedCommonFunctions.CustomLog("\(jsonDict)")
                        success(urlData)
                    }
                } catch let error as NSError {
                    CommonFunctions.sharedCommonFunctions.CustomLog("\(error)")
                    success(nil)
                }
            }else{
                //retrieve when is imposible connect to the service
                success(nil)
            }
        })
        
    }
    
    
    class func loadDataFromURLRawDelete(_ dataParameter: String, url: URL, completion:@escaping (_ data: NSData?, _ error: NSError?) -> Void) {
        CommonFunctions.sharedCommonFunctions.CustomLog("dataParameter: \(dataParameter)")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "DELETE"
        
        request.httpBody = dataParameter .data(using: String.Encoding.utf8, allowLossyConversion: false)//NSJSONSerialization.dataWithJSONObject(dataParameter, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        Variables.sharedVariables.currentTask = session.dataTask(with: request as URLRequest) {data, response, error in
            if let responseError = error {
                completion(nil, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                CommonFunctions.sharedCommonFunctions.CustomLog("el codigo es: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.activgard", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    //404 contains 200 response with error messages
                    if httpResponse.statusCode == 404  || httpResponse.statusCode == 401 {
                        completion(data as NSData?, statusError)
                    }else{
                        completion(nil, statusError)
                    }
                } else {
                    completion(data as NSData?, nil)
                }
            }
        }
        
        Variables.sharedVariables.currentTask!.resume()
    }
    
    
    class func loadDataFromURLDelete(_ url: URL, completion:@escaping (_ data: NSData?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "DELETE"
        
        Variables.sharedVariables.currentTask = session.dataTask(with: request as URLRequest) {data, response, error in
            if let responseError = error {
                completion(nil, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.activgard", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    //404 contains 200 response with error messages
                    if httpResponse.statusCode == 404{
                        completion(data as NSData?, statusError)
                    }else{
                        completion(nil, statusError)
                    }
                } else {
                    completion(data as NSData?, nil)
                }
            }
        }
        
        Variables.sharedVariables.currentTask!.resume()
    }
    
    class func loadDataFromURL(_ url: URL, completion:@escaping (_ data: NSData?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        Variables.sharedVariables.currentTask = session.dataTask(with: request as URLRequest) {data, response, error in
            if let responseError = error {
                completion(nil, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 202 {
                    let statusError = NSError(domain:"com.activgard", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    //404 contains 200 response with error messages
                    if httpResponse.statusCode == 404{
                        completion(data as NSData?, statusError)
                    }else{
                        completion(nil, statusError)
                    }
                } else {
                    completion(data as NSData?, nil)
                }
            }
        }
        
        Variables.sharedVariables.currentTask!.resume()
    }
    
    class func loadDataFromURLPostOrPut(_ dataParameter: [String:String], httpMethod: String, url: URL, completion:@escaping (_ data: NSData?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = httpMethod//POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dataParameter, options: JSONSerialization.WritingOptions.init(rawValue: 2))
        }
        catch {
            // Error Handling
            CommonFunctions.sharedCommonFunctions.CustomLog("NSJSONSerialization Error")
        }
        CommonFunctions.sharedCommonFunctions.CustomLog("dataParameter: \(dataParameter)")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        Variables.sharedVariables.currentTask = session.dataTask(with: request as URLRequest) {data, response, error in
            if let responseError = error {
                completion(nil, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                CommonFunctions.sharedCommonFunctions.CustomLog("el codigo es: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.activgard", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    //404 contains 200 response with error messages
                    if httpResponse.statusCode == 404  || httpResponse.statusCode == 401 {
                        completion(data as NSData?, statusError)
                    }else{
                        completion(nil, statusError)
                    }
                } else {
                    completion(data as NSData?, nil)
                }
            }
        }
        
        Variables.sharedVariables.currentTask!.resume()
    }
    class func loadDataFromURLPost(_ dataParameter: [String:AnyObject], httpMethod: String, url: URL, completion:@escaping (_ data: NSData?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = httpMethod//POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dataParameter, options: JSONSerialization.WritingOptions.init(rawValue: 2))
        }
        catch {
            // Error Handling
            CommonFunctions.sharedCommonFunctions.CustomLog("NSJSONSerialization Error")
        }
        CommonFunctions.sharedCommonFunctions.CustomLog("dataParameter: \(dataParameter)")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        Variables.sharedVariables.currentTask = session.dataTask(with: request as URLRequest) {data, response, error in
            if let responseError = error {
                completion(nil, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                CommonFunctions.sharedCommonFunctions.CustomLog("el codigo es: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.activgard", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    //404 contains 200 response with error messages
                    if httpResponse.statusCode == 404  || httpResponse.statusCode == 401 {
                        completion(data as NSData?, statusError)
                    }else{
                        completion(nil, statusError)
                    }
                } else {
                    completion(data as NSData?, nil)
                }
            }
        }
        
        Variables.sharedVariables.currentTask!.resume()
    }
    
}
