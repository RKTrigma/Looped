//
//  HomeViewController.swift
//  looped
//
//  Created by Raman Kant on 11/30/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , SWRevealViewControllerDelegate {

    @IBOutlet weak var collectionViewHome: UICollectionView!

    var arrayMenuIcons: [String]   = []
    var unradMsgsCoount : NSNumber!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        unradMsgsCoount = 0
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset             = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize                 = CGSize(width: self.view.frame.width/2, height: self.view.frame.width/2)
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing       = 0
        
        collectionViewHome!.collectionViewLayout = layout
        arrayMenuIcons = ["msg" , "feed" , "polls" , "surveys" , "calls" , "people"]
        
        self.addDefaultLeftBarItens()
        
        /*for familyName:String in UIFont.familyNames {
            print("Family Name: \(familyName)")
            for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
                print("--Font Name: \(fontName)")
            }
        }*/
        
        self.title = "looped"
        self.navigationController?.navigationBar.barStyle       = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor      = UIColor.white
        self.navigationController?.navigationBar.barTintColor   = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "GothamRounded-Medium", size: 20)!]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().delegate = self
        self.navigationController?.isNavigationBarHidden = false
        IQKeyboardManager.shared().isEnableAutoToolbar   = true
        
        self.unreadMessagesCount()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar   = false


    }
    
    func unreadMessagesCount () {
        
        let alUserService       = ALUserService()
        unradMsgsCoount         = alUserService.getTotalUnreadCount()
        print(unradMsgsCoount)
        self.collectionViewHome.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func addDefaultLeftBarItens () {
        
        let buttonMenu = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(SWRevealViewController.revealToggle(_:)))
        buttonMenu.tintColor = UIColor.white
        buttonMenu.target = revealViewController()
        
        self.navigationItem.leftBarButtonItems  = [buttonMenu]
    }
    
    func addUpdatedLeftBarItens () {
        
        let buttonCross = UIBarButtonItem(image: UIImage(named: "cross_icon"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(SWRevealViewController.revealToggle(_:)))
        buttonCross.tintColor = UIColor.white
        buttonCross.target = revealViewController()
        self.navigationItem.leftBarButtonItems  = [buttonCross]
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


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 6
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell                = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath as IndexPath) as! HomeCollectionViewCell
        cell.imageViewIcon.image  = UIImage(named: arrayMenuIcons[indexPath.row])
        if indexPath.row % 2 == 0 {
            cell.imageViewDivider.isHidden              = false
        }else{
            cell.imageViewDivider.isHidden              = true
        }
        
        cell.labelUnreadMsgsCount.shadowOffset          = CGSize(width: -15, height: 20)
        cell.labelUnreadMsgsCount.layer.shadowRadius    = 5;
        cell.labelUnreadMsgsCount.layer.shadowOpacity   = 0.5;
        
        switch indexPath.row {
        case 0:
            cell.labelUnreadMsgsCount.text  = String( describing: self.unradMsgsCoount! )
            self.unradMsgsCoount            == 0 ? (cell.labelUnreadMsgsCount.isHidden  = true) : (cell.labelUnreadMsgsCount.isHidden  = false)
        default:
            cell.labelUnreadMsgsCount.isHidden  = true
        }
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrayMenuIcons[indexPath.row] == "msg" {
            
            let viewController:UIViewController              = UIStoryboard(name: "Applozic", bundle: nil).instantiateViewController(withIdentifier: "ALViewController") as UIViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        if arrayMenuIcons[indexPath.row] == "feed" {
            
            let newsFeedsVC         = self.storyboard?.instantiateViewController(withIdentifier: "NewsFeedViewController") as! NewsFeedViewController
            self.navigationController?.pushViewController(newsFeedsVC, animated: false)
        }
        if arrayMenuIcons[indexPath.row] == "calls" {
            
            let callHistoryTBC = self.storyboard?.instantiateViewController(withIdentifier: "CallsHistoryTabBarContrller") as! CallsTabBarVC
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(callHistoryTBC, animated: false)
        }
    }
    
    // MARK: collection view cell layout / size
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let   returnSize = CGSize(width: (self.view.frame.width-5)/2 , height: (self.view.frame.width-5)/2)
        return returnSize
    }
    
    
    // MARK: collection view cell paddings
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
        // top, left, bottom, right
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }


}
