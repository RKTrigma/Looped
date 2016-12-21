//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    
    var _presentedRow               = NSInteger()
    
    var arrayMenuList:   [String]   = []
    var arrayMenuImages: [String]   = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        arrayMenuList   = ["Home","Messages" , "Feed" , "Calls" , "Intranet" , "People" , "Settings" , "Profile" , "Logout"]
        arrayMenuImages = ["home_icon" , "msg_icon_white" , "feed_icon" , "call_icon" , "intranet_icon" , "people_icon" , "settings_icon" , "profile_icon" , "logout_icon"]
        
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor      = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        self.tableView.tableHeaderView = addSearchBarToTableView()
        
    }
    
    
    func addSearchBarToTableView() -> UIView{
        
        let view                     = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80))
        view.backgroundColor         = UIColor.clear
        
        
        let imageView                = UIImageView(frame: CGRect(x: 15 , y: 20, width: 230, height: 40))
        imageView.backgroundColor    = UIColor(red: 226.0/255.0, green: 123.0/255.0, blue: 91.0/255.0, alpha: 0.5)
        imageView.layer.cornerRadius = 8
        
        
        let imageViewLeft            = UIImageView(frame: CGRect(x: 20 , y: 30, width: 20, height: 20));
        let image                    = UIImage(named: "search_icon-1");
        imageViewLeft.image          = image;
        
        
        let searchField              = UITextField(frame: CGRect(x: 50 , y: 25, width: 160, height: 30))
        searchField.borderStyle      = .none
        searchField.backgroundColor  = UIColor.clear
        searchField.attributedPlaceholder = NSAttributedString(string:"Search", attributes:[NSForegroundColorAttributeName: UIColor.white])
        searchField.font             = UIFont(name: "GothamRounded-Medium", size: 17)
        searchField.textColor        = UIColor.white
        
        view.addSubview(imageView)
        view.addSubview(imageViewLeft)
        view.addSubview(searchField)
        
        return view
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrayMenuList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath as IndexPath) as UITableViewCell
        // Configure the cell...
        
        let imageView          = cell.viewWithTag(1) as! UIImageView
        let textLabel          = cell.viewWithTag(2) as! UILabel
        
        textLabel.text         = arrayMenuList[indexPath.row]
        textLabel.textColor    = UIColor.white
        textLabel.font         = UIFont(name: "GothamRounded-Medium", size: 18)
        
        imageView.image        = UIImage(named: arrayMenuImages[indexPath.row])
        
        let imageViewLine               = UIImageView(frame: CGRect(x: 15, y: 59, width: 230, height: 1))
        imageViewLine.backgroundColor   = UIColor.lightGray
        imageViewLine.alpha             = 0.5
        cell.addSubview(imageViewLine)
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let row : NSInteger = indexPath.row;
        // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
        // we'll just set position and return
        
        // User Logout Action //
        if row == 8 {
            self.logOutAction()
            return
        }
        
        
        if row == _presentedRow{
            
            revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
            
            if row == 0 {
                
                revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                let navController = revealViewController().frontViewController as? UINavigationController
                _ = navController?.popToRootViewController(animated: false)
                
            }
                
            else if row == 1 {
                
                let navController = revealViewController().frontViewController as? UINavigationController
                _ = navController?.popToRootViewController(animated: false)
                
                //if navController?.viewControllers.count == 1 {
                //    let tabBarMessages  = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                //    navController?.pushViewController(tabBarMessages, animated: false)
                //}
                
                let viewController:UIViewController              = UIStoryboard(name: "Applozic", bundle: nil).instantiateViewController(withIdentifier: "ALViewController") as UIViewController
                navController?.pushViewController(viewController, animated: false)
                
                revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            }
                
            else if row == 2 {
                
                let navController = revealViewController().frontViewController as? UINavigationController
                _ = navController?.popToRootViewController(animated: false)
                if navController?.viewControllers.count == 1 {
                    let newsFeedsVC         = self.storyboard?.instantiateViewController(withIdentifier: "NewsFeedViewController") as! NewsFeedViewController
                    navController?.pushViewController(newsFeedsVC, animated: false)
                }
                revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            }
                
            else if row == 3 {
                
                let navController = revealViewController().frontViewController as? UINavigationController
                _ = navController?.popToRootViewController(animated: false)
                navController?.isNavigationBarHidden    = true
                if navController?.viewControllers.count == 1 {
                    let callHistoryTBC  = self.storyboard?.instantiateViewController(withIdentifier: "CallsHistoryTabBarContrller") as! UITabBarController
                    navController?.pushViewController(callHistoryTBC, animated: false)
                }
                revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            }
            return;
        }
        
        if row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            revealViewController().pushFrontViewController(vc, animated: true)
        }
        else if row == 1 {
            let navController   = revealViewController().frontViewController as? UINavigationController
            _ = navController?.popToRootViewController(animated: false)
            
            //let tabBarMessages  = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            let viewController:UIViewController              = UIStoryboard(name: "Applozic", bundle: nil).instantiateViewController(withIdentifier: "ALViewController") as UIViewController
            navController?.isNavigationBarHidden = false
            navController?.pushViewController(viewController, animated: false)
            
            revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        else if row == 2 {
            
            let navController   = revealViewController().frontViewController as? UINavigationController
            _ = navController?.popToRootViewController(animated: false)
            let newsFeedsVC         = self.storyboard?.instantiateViewController(withIdentifier: "NewsFeedViewController") as! NewsFeedViewController
            navController?.isNavigationBarHidden = false
            navController?.pushViewController(newsFeedsVC, animated: false)
            
            revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        else if row == 3{
            
            let navController   = revealViewController().frontViewController as? UINavigationController
            _ = navController?.popToRootViewController(animated: false)
            let callHistoryTBC  = self.storyboard?.instantiateViewController(withIdentifier: "CallsHistoryTabBarContrller") as! UITabBarController
            navController?.isNavigationBarHidden = true
            navController?.pushViewController(callHistoryTBC, animated: false)
            
            revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        _presentedRow = row;  // <- store the presented row //
    }
    
    
    func logOutAction() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let registerUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
            registerUserClientService.logout {
            }
            delegate.changeRootWithLogin()
        }
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        self.present(alert, animated: true, completion: nil)
        
        

        
    }
    
}
