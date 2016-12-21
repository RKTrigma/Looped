//
//  FavouriteVC.swift
//  looped
//
//  Created by Divya Khanna on 11/9/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class FavouriteVC: UIViewController , UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate,BaseBLDelegate , SWRevealViewControllerDelegate{
    
    //MARK: - Variables
    
    var arrayFavouriteUsersList                = NSArray()
    
    var dicFavDetails:NSDictionary  = [:]
    
    var arrname = NSMutableArray()
    var arrposition = NSMutableArray()
    var arrcountry = NSMutableArray()
    var arrimages: [UIImage] = []
    var  IndexTitles = NSArray()
    var arrchatimages: [UIImage] = []
    var filteredArray = NSMutableArray()
 

// MARK: - Outlets
    
    @IBOutlet var TableFavourite: UITableView!
    
    @IBOutlet var TextSearch: UITextField!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
     IndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z","#"]
        /*
        arrname.add("Anna")
        arrname.add("Andrew")
        arrname.add("Dennis")
        arrname.add("Diana")
        arrname.add("Jennifer")
        arrposition.add("HR Manager")
        arrposition.add("Marketing Analyst")
        arrposition.add("Ios Developer")
        arrposition.add("HR Executive")
        arrposition.add("Marketing manager")
        arrcountry.add("HR Team,Melbourne")
        arrcountry.add("Marketing Team,Germany")
        arrcountry.add("HR Team,Melbourne")
        arrcountry.add("App Devlopment,Sydney")
        arrcountry.add("Marketing Team,Sydney")
        arrimages =  [
            UIImage(named: "180x180")!,
            UIImage(named: "180x180")!,
            UIImage(named: "180x180")!,
            UIImage(named: "180x180")!,
            UIImage(named: "180x180")!,
        ]
        arrchatimages =  [
            UIImage(named: "green")!,
            UIImage(named: "red")!,
            UIImage(named: "green")!,
            UIImage(named: "red")!,
            UIImage(named: "yellow")!,
        ]
*/
        TableFavourite.tableFooterView = UIView()
        
        //self.addDefaultLeftBarItens()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().delegate = self
        //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.callFavouritelist(userid: UserDefaults.standard .value(forKey: "user_id")! as! String)
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
    
    
    
    
////    // MARK: - TextfieldFunctions
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
//        let string1 = string
//        let string2 = TextSearch.text
//        var finalString = ""
//        if string.characters.count > 0 { // if it was not delete character
//            finalString = string2! + string1
//        }
//        else if string2?.characters.count > 0{ // if it was a delete character
//            
//            finalString = String(string2!.characters.dropLast())
//        }
//        filteredArray(finalString)// pass the search String in this method
//        return true
//    }
//    
//    func filteredArray(searchString:NSString){// we will use NSPredicate to find the string in array
//        let predicate = NSPredicate(format: "SELF contains[c] %@",searchString) // This will give all element of array which contains search string
//        //let predicate = NSPredicate(format: "SELF BEGINSWITH %@",searchString)// This will give all element of array which begins with search string (use one of them)
//        filteredArray = arrname.filteredArrayUsingPredicate(predicate)
//        print(filteredArray)
//    }
    

    // MARK: - Call user list
    func callFavouritelist(userid: String){
        // Hit login WS.
        let loginBL: LoginBL = LoginBL()
        loginBL.delegate = self
        loginBL.favouriteList(self.view, userid: userid)
    }
    
    // MARK: - Call delete fav
    func callDelfavAPI(userid: String, favuser: String){
        // Hit login WS.
        let loginBL: LoginBL = LoginBL()
        loginBL.delegate = self
        loginBL.delFavouriteUser(self.view, userid: userid, favuser: favuser)
    }
    
    // MARK: - Actions
    
    @IBAction func pressButton(buttonDeleteFavUserAction: UIButton) {
        
        let btnDeleteFav = buttonDeleteFavUserAction
        
        let indexPathdeleteUser = btnDeleteFav.layer .value(forKey: "deleteUserIndex")
        
        let str_Delete_FavUserid = (arrayFavouriteUsersList .object(at: indexPathdeleteUser as! Int) as AnyObject) .value(forKey: "id") as! String
        
        self.callDelfavAPI(userid: UserDefaults.standard .value(forKey: "user_id")! as! String, favuser: str_Delete_FavUserid)

    }
    
    @IBAction func SeeSuggstnBtn(_ sender: AnyObject) {
    }
    
    @IBAction func menuBtn(_ sender: AnyObject) {
    }
    
    @IBOutlet var BackBtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Datasources
    func numberOfSections(in tableView: UITableView) -> Int {
        // Mutiple sections not required.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // Number of apps returned from search results.
//        if arrname == nil{
//            return 5
//        }else{
            return arrayFavouriteUsersList.count
       // }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteTableViewCell
//        cell.NameLabel.text = arrname[indexPath.row] as? String
//        cell.PositionLabel.text = arrposition[indexPath.row] as? String
//        cell.CountryLabel.text = arrcountry[indexPath.row] as? String
//        cell.UserImg.image = arrimages[indexPath.row]
//        cell.ChatActiveImg.image = arrchatimages[indexPath.row]
        
        cell.NameLabel?.text      = ((arrayFavouriteUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"name") as? String
        
        cell.CountryLabel?.text    = "\(((arrayFavouriteUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"company")as! String)" + " , " + "\(((arrayFavouriteUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"country")as! String)"
        
        cell.PositionLabel?.text   = ((arrayFavouriteUsersList .object(at: indexPath.row) ) as AnyObject) .value(forKey:"designation") as? String
        
        cell.btnDeleteUser.addTarget(self, action: #selector(self.pressButton(buttonDeleteFavUserAction:)), for: .touchUpInside)
        
        cell.btnDeleteUser.layer .setValue(indexPath.row, forKey: "deleteUserIndex")
        
        return cell
    }


    func sectionIndexTitles(for tableView: UITableView) -> [String] {
        return IndexTitles as! [String]
    }
    
    // MARK: - Response Received
    
    func successResponseReceived (_ response:AnyObject) {
        
        if response is NSDictionary {
            
            print(response)
            
            dicFavDetails = response as! NSDictionary
            let message = "\(dicFavDetails.value(forKey: "message")!)"
            
            if dicFavDetails.value(forKey: "status")! as? Int ==  1 {
                
                CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(message)")
            }
            else if (dicFavDetails.value(forKey: "status")! as? Int ==  101){
                
                arrayFavouriteUsersList = []
                
                arrayFavouriteUsersList = dicFavDetails.value(forKey: "data") as! NSArray
                
                print(arrayFavouriteUsersList)
                
                TableFavourite .reloadData()
            }
            else if (dicFavDetails.value(forKey: "status")! as? Int ==  102){
                arrayFavouriteUsersList = []
                TableFavourite .reloadData()
                CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(message)")
            }
            else if (dicFavDetails.value(forKey: "status")! as? Int ==  103){
                
                self.callFavouritelist(userid: UserDefaults.standard .value(forKey: "user_id")! as! String)
                TableFavourite .reloadData()
                CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(message)")
            }
            else
            {
                CommonFunctions.sharedCommonFunctions.showAlert(self, title: "", message: "\(message)")
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
    
    // MARK:- BUTTON BACK ACTION METHOD
    
    @IBAction func btnBackAction(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
