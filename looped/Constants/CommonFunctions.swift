//
//  CommonFunctions.swift
// Restaurant
//
//  Created by Divya Khanna on 9/23/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    // Calculate time between two dates
    
    func minutesFrom(_ date:Date) -> Int{
        return Calendar.current.component(.minute, from: date as Date)
        //return NSCalendar.currentCalendar.components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    
    func secondsFrom(_ date:Date) -> Int{
        return Calendar.current.component(.second, from: date as Date)
       // return NSCalendar.currentCalendar.components(.Second, fromDate: date, toDate: self, options: []).second
    }
}

class CommonFunctions {
    
    class var sharedCommonFunctions : CommonFunctions {
        struct Static {
            static let instance : CommonFunctions = CommonFunctions()
        }
        return Static.instance
    }
    
    // MARK: - Custom Log
    func CustomLog(_ message: String, function: String = #function) {
        // Enable/Disable Logs
        let enableLogs = 0
        if enableLogs == 0 {
            print("\(function): \(message)")
        }
    }
    
    // MARK: - Loading indicator Methods -
    func show_LoadingIndicator(_ strLoadingText: String, view:UIView) {
        let vwLoadingIndicator: UIView = UIView()
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 250, height: 110))
        vwLoadingIndicator.frame = rect
        vwLoadingIndicator.center = view.center
        vwLoadingIndicator.backgroundColor = UIColor.black
        vwLoadingIndicator.alpha = 0.7
        vwLoadingIndicator.layer.cornerRadius = 5
        vwLoadingIndicator.tag = 100
        view.addSubview(vwLoadingIndicator)
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        let rectOne = CGRect(origin: CGPoint(x: vwLoadingIndicator.frame.size.width/2 - 40/2,y :20.0), size: CGSize(width: 40.0, height: 40.0))
        loadingIndicator.frame = rectOne
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        loadingIndicator.tag = 101
        vwLoadingIndicator.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        var lblLoadingIndicator: UILabel! = UILabel()
        let titleSize = CGRect(x: 10, y: vwLoadingIndicator.frame.size.height - 50, width: 230, height: 50)
        lblLoadingIndicator = UILabel()
        lblLoadingIndicator.frame = titleSize
        lblLoadingIndicator.text = strLoadingText + "..."
        lblLoadingIndicator.textColor = UIColor.white
        lblLoadingIndicator.textAlignment = NSTextAlignment.center
        lblLoadingIndicator.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblLoadingIndicator.numberOfLines = 0
        lblLoadingIndicator.isHidden = false
        lblLoadingIndicator.tag = 111
        vwLoadingIndicator.addSubview(lblLoadingIndicator)
    }
    
    func hide_LoadingIndicatorOnView(_ view:UIView) {
        for vw in view.subviews {
            if vw.tag == 100 {
                for actInd in vw.subviews {
                    if actInd.isKind(of: UIActivityIndicatorView.self) {
                    //if actInd .isKindOfClass(UIActivityIndicatorView) {
                        if actInd.tag == 101 {
                            actInd.removeFromSuperview()
                        }
                    }
                }
                vw.removeFromSuperview()
            }
        }
    }
    
    func inactivateView(_ view: UIView, loaderText: String) {
        view.isUserInteractionEnabled = false
        self.show_LoadingIndicator(loaderText, view: view)
    }
    
    func activateView(_ view: UIView) {
        view.isUserInteractionEnabled = true
        self.hide_LoadingIndicatorOnView(view)
    }
    
    // MARK: - Push/Pop Animation
    func addPushAnimation () -> CATransition {
        let animation:CATransition  = CATransition()
        animation.duration          = 0.5
        animation.type              = kCATransitionPush
        animation.subtype           = kCATransitionFromRight
        animation.timingFunction    = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    func addPopAnimation () -> CATransition {
        let animation:CATransition = CATransition()
        animation.duration       = 0.5
        animation.type           = kCATransitionPush
        animation.subtype        = kCATransitionFromLeft
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    // MARK: - Title Label for Navigation Bar -
    func titleForNavBar(_ text:String) -> UILabel {
        let navString: NSString = text as NSString
        var completedNavString = NSMutableAttributedString()
        completedNavString = NSMutableAttributedString(string: navString as String, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 17.0)])
        let navLabel = UILabel()
        navLabel.textColor = UIColor.white
        navLabel.attributedText = completedNavString
        navLabel.sizeToFit()
        return navLabel
    }
   
    func titleAndImageForNavBar(_ text:String) -> UIButton {
        let image: UIImage = UIImage(named: "Logo")!
        let btnTitle: UIButton = UIButton()
        btnTitle.setImage(image, for: UIControlState.normal)
        btnTitle.setTitle(text, for: .normal)
        btnTitle.imageEdgeInsets = UIEdgeInsetsMake(image.size.height/2,(btnTitle.frame.size.width-10),image.size.height/2,0)
        return btnTitle
    }
    
    func titleImageForNavBar() -> UIImageView {
        let image: UIImage = UIImage(named: "TitleLogo")!
        let imgVw: UIImageView = UIImageView(image: image)
        return imgVw
    }
    
    // MARK: - Convert Any Object To String -
    func convertObjectToString (_ value:AnyObject) -> String {
        CommonFunctions.sharedCommonFunctions.CustomLog("value: \(value)")
        var covertedStr = ""
        if let boolVal = value as? Bool {
            if boolVal == true {
                covertedStr = "YES"
            }
            else {
                covertedStr = "NO"
            }
        }
        else if let intVal = value as? Int {
            if intVal == 1 {
                covertedStr = "\(value)"
            }
            else {
                covertedStr = "\(value)"
            }
        }
        else if let stringVal = value as? String {
            if stringVal != "" {
                covertedStr = stringVal
            }
            else {
                covertedStr = ""
            }
        }else {
            covertedStr = ""
        }
        return covertedStr
    }
    
    // MARK: - Convert recieved date to required format
    func convertDateToAnotherFormat(_ strDate:String, fromFormat:String, toFormat:String) -> String {
        // Convert date into required date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        if let receivedDate = dateFormatter.date(from: strDate) {
            let anotherDateFormatter = DateFormatter()
            anotherDateFormatter.dateFormat = toFormat
            let strNoteDate = anotherDateFormatter.string(from: receivedDate)
            return strNoteDate
        }
        else {
            return ""
        }
    }
    
    // MARK: - Validate Email
    func isValidEmail(_ emailId:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailPredicate.evaluate(with: emailId) {
            return true
        }
        return false
    }
    
    func phoneNumberValidation(_ value: String) -> Bool {
        let phone_regex = "(\\+?)(\\d{10,13})"
        //        let phone_regex = "^\\d{3}-\\d{3}-\\d{4}$"
        //        let phone_regex = "[789][0-9]{9}"
        
        //        let phone_regex = "((\\+)|(00))[0-9]{6,14}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@",phone_regex)
        return phoneTest.evaluate(with: value)
        
    }

    
    // MARK: - Check Font Names
    func checkFontNames () {
        for familyName:String in UIFont.familyNames
        {
            print("Family Name: \(familyName)")
            for fontName:String in UIFont.fontNames(forFamilyName: familyName )
            {
                print("--Font Name: \(fontName)")
            }
        }
    }
    
    // MARK: - Set Textfield Padding
    func setLeftPadding(_ textfield:UITextField, rect:CGRect) -> UIView {
        let paddingView: UIView = UIView(frame: rect)
        textfield.leftViewMode = UITextFieldViewMode.always
        return paddingView
    }
    
    func setRightPadding(_ textfield:UITextField, rect:CGRect) -> UIView {
        let paddingView: UIView = UIView(frame: rect)
        textfield.rightViewMode = UITextFieldViewMode.always
        return paddingView
    }
    
    // MARK: - Set textfield border
    func setBorderForTextfield(_ textfield:UITextField) {
        textfield.layer.borderColor = UIColor(red: 230.0/255.0, green: 229.0/255.0, blue: 231.0/255.0, alpha: 1.0).cgColor
        textfield.layer.borderWidth = 1.0
    }
    
    // MARK: - Vertically align button
    func setInsetsToVerticallyCenterButton(_ button:UIButton) {
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0)
    }
    
    // MARK: - Show Alert
    func showAlert(_ view:UIViewController,title:String,message:String) {
        
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            view.present(alert, animated: true, completion: nil)
    }
    
    
    }
