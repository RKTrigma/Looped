//
//  DemoViewController.swift
//  looped
//
//  Created by Divya Khanna on 10/17/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vwData: UIView!
    @IBOutlet var txtEmailAddress: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var viewDataY: NSLayoutConstraint!
    @IBOutlet var imgLogoTopSpace: NSLayoutConstraint!
    
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imgLogoTopSpace.constant = 0.1 * self.view.frame.size.height

        self.imgLogo.frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2-31, width: 200, height: 61)

        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            //95
            self.imgLogo.frame = CGRect(x: self.view.frame.size.width/2, y: 0.171 *  self.view.frame.height, width: 200, height: 61)
        })
        
        
        
        UIView.animate(withDuration: 0.7, delay: 0.2, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            self.vwData.center.x -= self.view.bounds.width
           
        })

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Actions
    @IBAction func btnLoginClicked(_ sender: AnyObject) {
        if (txtEmailAddress.text?.isEmpty)!  || (txtPassword.text?.isEmpty)! {
            showAlert(self, title: "", message:  "emptyLoginCredentials".localized)
        }else{
            let validEmail = txtEmailAddress.text?.isValidEmail
            //let validEmail = isValidEmail(testStr: txtEmailAddress.text!)
            if validEmail == false{
                showAlert(self, title: "", message: "correctEmail".localized)
            }
        }
    }
    
    //MARK: - Custom Methods
    func showAlert(_ view:UIViewController,title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmailh(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }


}
