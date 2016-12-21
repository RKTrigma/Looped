//
//  NewGroupVC.swift
//  looped
//
//  Created by Nitin Suri on 23/11/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class NewGroupVC: UIViewController , UITableViewDataSource , UITableViewDelegate , SWRevealViewControllerDelegate {

    // MARK: OUTLETS
    
    @IBOutlet var textGroupPurpose: UITextField!
    
    @IBOutlet var textGroupSubject: UITextField!
    
    @IBOutlet var textAddPeople: UITextField!
    
    @IBOutlet var lblPurposeTextCount: UILabel!
    
    @IBOutlet var btnCreateOutlet: UIButton!
    @IBOutlet var btnSeeGroupsOutlet: UIButton!
    @IBOutlet var btnSelectAllOutlet: UIButton!
    @IBOutlet var tableNewGroup: UITableView!
    
    // MARK: VARIABLES
    
    var arrname = NSMutableArray()
    var arrposition = NSMutableArray()
    var arrcountry = NSMutableArray()
    var arrimages: [UIImage] = []
    var arrchatimages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "New Group"
        
        self.addDefaultLeftBarItens()
        
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
        
        // MARK BUTTON OUTLET CORNER RADIUS AND BORDER COLOUR
        
        btnCreateOutlet.layer .cornerRadius = 3
        btnCreateOutlet.layer.borderWidth   = 1
        btnCreateOutlet.layer.borderColor   = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0).cgColor
        
        btnSeeGroupsOutlet.layer .cornerRadius = 3
        btnSeeGroupsOutlet.layer.borderWidth   = 1
        btnSeeGroupsOutlet.layer.borderColor   = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0).cgColor
        
        btnSelectAllOutlet.layer .cornerRadius = 3
        btnSelectAllOutlet.layer.borderWidth   = 1
        btnSelectAllOutlet.layer.borderColor   = UIColor(red: 71.0/255.0, green: 193.0/255.0, blue: 30.0/255.0, alpha: 1.0).cgColor
        
        // 71 193 30
 
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

    // MARK: - TableView Datasources -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newGroupCell", for: indexPath) as! newgroupCell
        
     cell.selectionStyle = .none
     cell.lblName.text = arrname[indexPath.row] as? String
     cell.lblDesignation.text = arrposition[indexPath.row] as? String
     cell.lblTeamCountry.text = arrcountry[indexPath.row] as? String
     cell.imageUser.image = arrimages[indexPath.row]
     //cell.ChatActiveImg.image = arrchatimages[indexPath.row]
        
        return cell
    }
    
    
    // MARK: TABLEVIEW DELEGATES
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
    }

}
