//
//  DialogsTableViewController.swift
//  looped
//
//  Created by Raman Kant on 11/1/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class DialogsTableViewController: UITableViewController , SWRevealViewControllerDelegate {
    

    var arrimages: [UIImage] = []
    
    // MARK:- View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.addDefaultLeftBarItens()

        self.navigationItem.setHidesBackButton(true, animated: false)
        self.tableView.tableFooterView  = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController().delegate = self
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
        self.navigationItem.leftBarButtonItems  = [buttonCross]
    }
    
    func actionBack(){
        _ = self.tabBarController?.navigationController?.popViewController(animated: true)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btncomposescreen(_ sender: AnyObject) {
        let composeTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComposeMessageVC") as! ComposeMessageVC
        self.navigationController?.pushViewController(composeTableViewController, animated: false)
    }
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! DialogsCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation -
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}




