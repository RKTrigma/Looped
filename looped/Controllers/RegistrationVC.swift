//
//  RegistrationVC.swift
//  looped
//
//  Created by Nitin Suri on 15/11/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController , UITextFieldDelegate {
    
    
    //MARK:- Outlets -
    
    @IBOutlet var textCompanyName: UITextField!
    @IBOutlet var textName: UITextField!
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textConfirmPassword: UITextField!
    @IBOutlet var textPhone: UITextField!
    @IBOutlet var textDesignation: UITextField!
    @IBOutlet var textConfirmCountry: UITextField!
    @IBOutlet var textConfirmVerificationCode: UITextField!
    
    
    // MARK VARIABLES
    
    var dicRegLoginDetails:NSDictionary = [:]
    
    //MARK:- Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- BUTTON SIGNUP-REGISTER CLICKED -
    
    @IBAction func btnSignUpClicked(_ sender: AnyObject) {
        
        if (textCompanyName.text?.isEmpty)!  || (textName.text?.isEmpty)! || (textEmail.text?.isEmpty)! || (textPassword.text?.isEmpty)! || (textConfirmPassword.text?.isEmpty)! || (textPhone.text?.isEmpty)! || (textDesignation.text?.isEmpty)! || (textConfirmCountry.text?.isEmpty)! || (textConfirmVerificationCode.text?.isEmpty)! {
            showAlert(self, title: "", message:  "STR_EMPTY_CREDENTIALS".localized)
            return
        }
        else if ((textPassword.text?.characters.count)! <= 8 && (textPassword.text?.characters.count)! >= 15)
        {
            let alertViewShow = UIAlertController(title:"looped", message: "Password is minimum 8 characters." as String, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alertViewShow.addAction(okAction)
            self.present(alertViewShow, animated: true, completion: nil)
        }
        else if textPassword.text != textConfirmPassword.text {
            
            let alertViewShow = UIAlertController(title:"looped", message: "Password and confirm password does not match." as String, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alertViewShow.addAction(okAction)
            self.present(alertViewShow, animated: true, completion: nil)
        }
        else{
            
            
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)

            let servicesManager = ServicesManager()
            let userDetails : NSMutableDictionary    = [ "company" : textCompanyName.text! , "name" : textName.text! , "email" : textEmail.text! , "password" : textPassword.text! , "phone" : textPhone.text! , "designation" : textDesignation.text! , "country" : textConfirmCountry.text! , "device_token" : "s6d54f5sd4f564sd65f465sd4f654sd6f54" ];
            servicesManager.registerUser(userCredentials: userDetails, completion: { (result, error) in
                
                if (error == nil){
                    if result.value(forKey: "status") as! Int == 1{
                        self.loginUserOnApplogic()
                    }else if result.value(forKey: "status") as! Int == 0{
                        self.showAlert(self, title: "Looped", message: result.value(forKey: "message") as! String)
                    }
                }else{
                        self.showAlert(self, title: "Looped", message: (error?.description)!)

                }
                
            })
        }
    }
    
    // MARK:- BUTTON BACK ACTION -
    
    @IBAction func btnBackActionClicked(_ sender: AnyObject) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newLength = 0
        if textField == textPhone {
            newLength = textPhone.text!.characters.count + string.characters.count - range.length
            return newLength <= 10

        }
        else if textField == textCompanyName {
            newLength = textCompanyName.text!.characters.count + string.characters.count - range.length
            return newLength <= 20
        }
        else if textField == textName {
            newLength = textName.text!.characters.count + string.characters.count - range.length
            return newLength <= 20
        }
        else if textField == textPassword {
            newLength = textPassword.text!.characters.count + string.characters.count - range.length
            return newLength <= 16
        }
        else if textField == textConfirmPassword {
            newLength = textConfirmPassword.text!.characters.count + string.characters.count - range.length
            return newLength <= 16
        }
        else if textField == textDesignation {
            newLength = textDesignation.text!.characters.count + string.characters.count - range.length
            return newLength <= 20
        }
        else if textField == textConfirmCountry {
            newLength = textConfirmCountry.text!.characters.count + string.characters.count - range.length
            return newLength <= 25
        }
        else{
            return newLength <= 16

        }
    }
    
    //MARK: - Custom Methods -
    func showAlert(_ view:UIViewController,title:String,message:String) {
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
       
        }
    }
    
    func loginUserOnApplogic () {
        
        
        let userID              = textName.text!
        let emailID             = textEmail.text!
        let password            = textPassword.text!
        let alUser : ALUser     =  ALUser();
        alUser.applicationId    = ALChatManager.applicationId
        if(ALChatManager.isNilOrEmpty( userID as NSString?)){
            let alert = UIAlertController(title: "Applozic", message: "Please enter userId ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        alUser.userId = userID
        ALUserDefaultsHandler.setUserId(alUser.userId)
        print("userName:: " , alUser.userId)
        if(!((emailID.isEmpty))){
            alUser.email    = emailID
            ALUserDefaultsHandler.setEmailId(alUser.email)
        }
        
        if (!((password.isEmpty))){
            alUser.password = password
            ALUserDefaultsHandler.setPassword(alUser.password)
        }
        
        let chatManager     = ALChatManager(applicationKey: "3924fba685219720ba693203bba01df21")
        chatManager.registerUser(alUser) { (response, error) in
            
            SVProgressHUD.dismiss()
            UserDefaults.standard.set(true, forKey: "Login")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeRootWithTabBarControler()
        }
    }
}
