//
//  ComposeMessageVC.swift
//  looped
//
//  Created by Divya Khanna on 11/9/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class ComposeMessageVC: UIViewController , UITableViewDataSource , UITableViewDelegate , UINavigationControllerDelegate , UITextFieldDelegate , SWRevealViewControllerDelegate {
    //MARK: - Variables
    var arrname = NSMutableArray()
    var arrposition = NSMutableArray()
    var arrcountry = NSMutableArray()
    var  IndexTitles = NSArray()
    var arrchatimages: [UIImage] = []
    // MARK: - Outlets
    
    @IBOutlet var TextSearch: UITextField!
    
      
    @IBOutlet var TableData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
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
 IndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z","#"]
        arrchatimages =  [
            UIImage(named: "green")!,
            UIImage(named: "red")!,
            UIImage(named: "green")!,
            UIImage(named: "red")!,
            UIImage(named: "yellow")!,
        ]
        
        TableData.tableFooterView = UIView()
       
        self.addDefaultLeftBarItens()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().delegate = self
        //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
        _ = navigationController?.popViewController(animated: true)
        
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
    
    // MARK: - Actions

    @IBAction func BtnNewGroup(_ sender: AnyObject) {
    
        let usersTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersTableViewController") as! UsersTableViewController
//                usersTableViewController.delegateSelf = self
                self.navigationController?.pushViewController(usersTableViewController, animated: true)

//        let newGroupVC = self.storyboard?.instantiateViewController(withIdentifier: "NewGroupVC") as! NewGroupVC
//  //                usersTableViewController.delegateSelf = self
//        self.navigationController?.pushViewController(newGroupVC, animated: true)
        
    
    }
    
    @IBAction func MARKOutletsBtnNewSubject(_ sender: AnyObject) {
        
        //let callHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "CallHistoryVC") as! CallHistoryVC
        //self.navigationController?.pushViewController(callHistoryViewController, animated: true)
    }
    
    
    @IBAction func Btnsidebar(_ sender: AnyObject) {
    }
    
    
    @IBAction func btnback(_ sender: AnyObject) {
       _ = navigationController?.popViewController(animated: true)
        
    }
    
    
 // MARK: - Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
              
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - TableView Datasources
    func numberOfSections(in tableView: UITableView) -> Int {
        // Mutiple sections not required.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // Number of apps returned from search results.
        if arrname == nil{
            return 5
        }else{
            return arrname.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "composeCell", for: indexPath) as! ComposeMessageTableViewCell
        cell.LabelName.text = arrname[indexPath.row] as? String
        cell.LabelPosition.text = arrposition[indexPath.row] as? String
        cell.LabelLocation.text = arrcountry[indexPath.row] as? String
        cell.imgChatonline.image = arrchatimages[indexPath.row]
        return cell
    }

    func sectionIndexTitles(forTableView tableView: UITableView) -> NSArray {
        return IndexTitles
    }
 

    
}
