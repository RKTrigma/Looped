//
//  DemoViewController.swift
//  looped
//
//  Created by Divya Khanna on 10/17/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet var vwData            : UIView!
    @IBOutlet var txtEmailAddress   : UITextField!
    @IBOutlet var txtPassword       : UITextField!
    @IBOutlet var imgLogo           : UIImageView!
    @IBOutlet var viewDataY         : NSLayoutConstraint!
    @IBOutlet var imgLogoTopSpace: NSLayoutConstraint!
    
    var dicLoginDetails:NSDictionary = [:]
    
    //MARK:- Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgLogoTopSpace.constant    = 0.1 * self.view.frame.size.height
        self.imgLogo.frame          = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2-31, width: 200, height: 61)
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            self.imgLogo.frame      = CGRect(x: self.view.frame.size.width/2, y: 0.171 *  self.view.frame.height, width: 200, height: 61)
        })
        UIView.animate(withDuration: 0.7, delay: 0.2, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            self.vwData.center.x    -= self.view.bounds.width
        })
        
        IQKeyboardManager.shared().isEnableAutoToolbar   = true
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
    
    
    //MARK:- Actions -
    @IBAction func btnLoginClicked(_ sender: AnyObject) {
        
        if (txtEmailAddress.text?.isEmpty)!  || (txtPassword.text?.isEmpty)! {
            showAlert(self, title: "", message:  "STR_EMPTY_CREDENTIALS".localized)
            return
        }
        else{
            
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
            
            let userCredentials     = ["email" : txtEmailAddress.text! , "password" : txtPassword.text! , "device_token" : "s6d54f5sd4f564sd65f465sd4f654sd6f54"] as NSMutableDictionary
            let servicesManager     = ServicesManager()
            servicesManager.logInUser(userCredentials: userCredentials, completion: { (result, error) in
                
                if (error == nil){
                    if result?.value(forKey: "status") as! Int == 1{
                        self.loginUserOnApplogic()
                    }else if result?.value(forKey: "status") as! Int == 0{
                        self.showAlert(self, title: "Looped", message: result?.value(forKey: "message") as! String)
                    }
                }else{
                    self.showAlert(self, title: "Looped", message: (error?.description)!)
                }
            })
        }
    }
    
    @IBAction func btnSetUpAccountClicked(_ sender: AnyObject) {
        
        let registrationViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        self.navigationController?.pushViewController(registrationViewController, animated: true)
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
        
        
        SVProgressHUD.dismiss()
        
        let userID      = txtEmailAddress.text
        let emailID     = ""
        let password    = txtPassword.text
        
        let alUser : ALUser  =  ALUser();
        alUser.applicationId = ALChatManager.applicationId
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
            alUser.email = emailID
            ALUserDefaultsHandler.setEmailId(alUser.email)
        }
        
        if (!((password?.isEmpty)!)){
            alUser.password = password
            ALUserDefaultsHandler.setPassword(alUser.password)
        }
        
        let chatManager = ALChatManager(applicationKey: "3924fba685219720ba693203bba01df21")
        chatManager.registerUser(alUser) { (response, error) in
            
            SVProgressHUD.dismiss()
            UserDefaults.standard.set(true, forKey: "Login")
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.changeRootWithTabBarControler()
            
        }
    }
    
}
