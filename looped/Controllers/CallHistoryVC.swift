//
//  CallHistoryVC.swift
//  looped
//
//  Created by Nitin Suri on 19/11/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class CallHistoryVC: UIViewController , BaseBLDelegate , UITableViewDelegate , UITableViewDataSource , SWRevealViewControllerDelegate {
    
    @IBOutlet var tableViewFavourite: UITableView!
    var arrayUsersList                = NSArray()
    
    var selectedCellIndexPath:        NSIndexPath?
    
    var dicLoginDetails:NSDictionary  = [:]
    
    let selectedCellHeight: CGFloat = 120
    let unselectedCellHeight: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Call History"
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.barStyle  = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.addDefaultLeftBarItens()
        
        //self.getUsers()
        self.callWbuserlist(userid: UserDefaults.standard .value(forKey: "user_id")! as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().delegate = self
        //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDefaultLeftBarItens () {
        
        let buttonMenu = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(SWRevealViewController.revealToggle(_:)))
        buttonMenu.tintColor = UIColor.white
        buttonMenu.target = revealViewController()
        
        let buttonBack = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ComposeMessageVC.actionBack))
        buttonBack.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItems  = [buttonMenu,buttonBack]
    }
    
    func addUpdatedLeftBarItens () {
        
        let buttonCross = UIBarButtonItem(image: UIImage(named: "cross_icon"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(SWRevealViewController.revealToggle(_:)))
        buttonCross.tintColor = UIColor.white
        buttonCross.target = revealViewController()
        
        //let buttonBack = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ComposeMessageVC.actionBack))
        //buttonBack.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItems  = [buttonCross]
    }
    
    func actionBack(){
        _ = self.tabBarController?.navigationController?.popViewController(animated: false)

    }
    
    //MARK: - SWRevealViewController Delegates -
    
    func revealControllerPanGestureEnded(_ revealController: SWRevealViewController) {
        print("\(revealViewController().frontViewPosition)")
        
        if self.revealViewController() == nil {
            return
        }
        
        if self.revealViewController().frontViewPosition == FrontViewPosition.right {
            print("OPEN")
            self.addUpdatedLeftBarItens()
            self.view.isUserInteractionEnabled = true
            
        }else{
            print("CLOSE")
            self.addDefaultLeftBarItens()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func revealController(_ revealController: SWRevealViewController, animateTo position: FrontViewPosition) {
        
        
        if self.revealViewController() == nil {
            return
        }
        
        if self.revealViewController().frontViewPosition == FrontViewPosition.right {
            print("OPEN")
            self.addUpdatedLeftBarItens()
            self.view.isUserInteractionEnabled = false
            
        }else{
            print("CLOSE")
            self.addDefaultLeftBarItens()
            self.view.isUserInteractionEnabled = true
        }
    }

    
    // MARK: - Table view data source
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if selectedCellIndexPath == indexPath as NSIndexPath? {
            return selectedCellHeight
        }
        return unselectedCellHeight
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.arrayUsersList.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CallHistoryViewCell
        // Configure the cell...
        
        cell.selectionStyle = .none
       
        cell.lblName?.text      = ((arrayUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"name") as? String
        
        cell.lblTeam?.text      = "\(((arrayUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"company")as! String)" + " , " + "\(((arrayUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"country")as! String)"
        
        cell.lblDesignation?.text = ((arrayUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"designation") as? String
        
        cell.lblDate?.text        = ((arrayUsersList .object(at: indexPath.row)) as AnyObject) .value(forKey: "date") as? String
        
        cell.btnHistoryOutlet.layer .cornerRadius = 3
        cell.btnHistoryOutlet.layer.borderWidth   = 1
        cell.btnHistoryOutlet.layer.borderColor   = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0).cgColor
        
        cell.btnAddToFavOutlet.addTarget(self, action: #selector(self.pressButton(buttonFavAction:)), for: .touchUpInside)
        
        cell.btnAddToFavOutlet.layer .setValue(indexPath.row, forKey: "favUserIndex")
        
        //cell.
        
        cell.imageUser?.image               = UIImage(named:"60x60")
        cell.imageUser?.layer.cornerRadius  = 30
        cell.imageUser?.layer.borderWidth   = 2
        cell.imageUser?.layer.borderColor   = UIColor.red.cgColor
        
       // cell.viewRedTopLine.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath as NSIndexPath? {
            selectedCellIndexPath = nil
        } else {
            selectedCellIndexPath = indexPath as NSIndexPath?
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if selectedCellIndexPath != nil {
            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
        
    }
    
    // MARK: - Call user list
    func callWbuserlist(userid: String){
        // Hit login WS.
        let loginBL: LoginBL = LoginBL()
        loginBL.delegate = self
        loginBL.userList(self.view, userid: userid)
    }
    
    // MARK: - Call user list
    func callAddTofavAPI(userid: String, favuser: String){
        // Hit login WS.
        let loginBL: LoginBL = LoginBL()
        loginBL.delegate = self
        loginBL.addToFavourite(self.view, userid: userid, favuser: favuser)
    }
    
    
    // MARK: - Response Received
    
    func successResponseReceived (_ response:AnyObject) {
        
        if response is NSDictionary {
            
           print(response)
            
            dicLoginDetails = response as! NSDictionary
            let message = "\(dicLoginDetails.value(forKey: "message")!)"
            
            if dicLoginDetails.value(forKey: "status")! as? Int ==  1 {
                
            CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(message)")
                
            }
            else if (dicLoginDetails.value(forKey: "status")! as? Int ==  101){
                
                arrayUsersList = dicLoginDetails.value(forKey: "data") as! NSArray
                
                tableViewFavourite .reloadData()
            }
            else if (dicLoginDetails.value(forKey: "status")! as? Int ==  123)
            {
                CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(message)")
            }
            else if (dicLoginDetails.value(forKey: "status")! as? Int ==  111)
            {
                CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(message)")
            }
            else
            {
                
            }
        
        }
        
    }
    
    func failureResponseReceived (_ response:AnyObject) {
        // Error received in response.
        
        CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(response)")
    }
    
    func noDataReceived () {
        // No data received in response.
        CommonFunctions.sharedCommonFunctions.showAlert(self, title: noDataAvailableTitle, message:pleaseTryAgainMsg)
    }
    
    // MARK: BUTTON ACTIONS

    @IBAction func pressButton(buttonFavAction: UIButton) {
        
        let btnAddFav = buttonFavAction
        
        let indexPathFavUser = btnAddFav.layer .value(forKey: "favUserIndex")
        
        let str_FavUserid = (arrayUsersList .object(at: indexPathFavUser as! Int) as AnyObject) .value(forKey: "id") as! String
        
        self.callAddTofavAPI(userid: UserDefaults.standard .value(forKey: "user_id")! as! String, favuser: str_FavUserid)
    }
    
    
    @IBAction func btnVideoCallAction(_ sender: AnyObject) {
        
        
    }
    
    @IBAction func btnVoiceCallAction(_ sender: AnyObject) {
        
        
    }
    @IBAction func btnMessageAction(_ sender: AnyObject) {
    }

    @IBAction func btnHistoryAction(_ sender: AnyObject) {
    }
    
    
    
    
}
