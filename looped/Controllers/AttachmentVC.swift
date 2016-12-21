//
//  AttachmentVC.swift
//  looped
//
//  Created by Divya Khanna on 11/10/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class AttachmentVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , SWRevealViewControllerDelegate {
  
    //MARK: - Variables
    var arrname                 = NSMutableArray()
    var arrimages: [UIImage]    = []
    var arrsectionname          = NSMutableArray()
    var screenSize:     CGRect!
    var screenWidth:    CGFloat!
    var screenHeight:   CGFloat!
    
    
    @IBOutlet var TxtSearch: UITextField!
    
    @IBOutlet var CollectnAttachmnts: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        arrname.add("Dolerem manga")
        arrname.add("Loreum ipsum")
        arrname.add("Dolerem manga")
        arrname.add("Tempore")
    
        arrimages =  [
            UIImage(named: "img1-1")!,
            UIImage(named: "img2-1")!,
            UIImage(named: "img3-1")!,
            UIImage(named: "img4-1")!
        ]

        arrsectionname.add("Today")
        arrsectionname.add("Jul 12")
        arrsectionname.add("Jul 05")
        arrsectionname.add("Jul 2016")
        
        screenSize      = UIScreen.main.bounds
        screenWidth     = screenSize.width
        screenHeight    = screenSize.height
        let layout: UICollectionViewFlowLayout      = UICollectionViewFlowLayout()
        layout.sectionInset                         = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 1)
        layout.itemSize                             = CGSize(width: screenWidth/4-1, height: screenWidth/4-1)
        layout.minimumInteritemSpacing              = 1
        layout.minimumLineSpacing                   = 1
        layout.headerReferenceSize                  = CGSize(width: screenWidth, height: 25.0)
        CollectnAttachmnts!.collectionViewLayout    = layout
        
        
        //self.addDefaultLeftBarItens()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

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

    
    //MARK: - Collectionview Delegates -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrsectionname.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return arrname.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! AttachmentCollectionViewCell
        
        cell.TitleLabel.text = arrname[indexPath.row] as? String
        cell.imgview.image = arrimages[indexPath.row]

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let attachmentdetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "AttachmentDetailVC") as! AttachmentDetailVC
        self.navigationController?.pushViewController(attachmentdetailViewController, animated: false)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView? = nil
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            //var title = "Recipe Group #\(indexPath.section + 1)"
            headerView.lblTitle.text = arrsectionname[indexPath.section] as? String
            reusableview = headerView
        }
                return reusableview!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
