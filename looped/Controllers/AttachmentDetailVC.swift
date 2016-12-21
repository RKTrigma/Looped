//
//  AttachmentDetailVC.swift
//  looped
//
//  Created by Divya Khanna on 11/11/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class AttachmentDetailVC: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , SWRevealViewControllerDelegate {
    
    //MARK: - Variables
    var arrimages: [UIImage]    = []
    var arrimages1: [UIImage]   = []
    
    var currentImageIndex       = Int()
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    
    
 // MARK: - Outlets
    
    @IBOutlet var CollectnImages: UICollectionView!
    @IBOutlet var collectionBottum: UICollectionView!
    @IBOutlet var Scroll: UIScrollView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//     arrimages.append(UIImage(named: "img")!)
        arrimages =  [
            UIImage(named: "img")!,
            UIImage(named: "img")!,
            UIImage(named: "img")!
        ]
        
        arrimages1 =  [
            UIImage(named: "img")!,
            UIImage(named: "img")!,
            UIImage(named: "img")!,
            UIImage(named: "img")!,
            UIImage(named: "img")!,
            UIImage(named: "img")!
        ]
        
        
        currentImageIndex = 0
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize     = CGSize(width: CollectnImages.frame.size.width, height: CollectnImages.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        CollectnImages!.collectionViewLayout = layout
        
        
        
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout1.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout1.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        layout1.minimumInteritemSpacing = 1
        layout1.minimumLineSpacing = 1
        layout1.scrollDirection = .horizontal
        collectionBottum!.collectionViewLayout = layout1
        
        //self.addDefaultLeftBarItens()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /*let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize     = CGSize(width: CollectnImages.frame.size.width, height: CollectnImages.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        CollectnImages!.collectionViewLayout = layout*/
        
        layout.itemSize     = CGSize(width: CollectnImages.frame.size.width, height: CollectnImages.frame.size.height)

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
        _ = self.navigationController?.popViewController(animated: false)
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
    
    
    @IBAction func BtnExpand(_ sender: AnyObject) {
    }

    @IBAction func BtnShrink(_ sender: AnyObject) {
    }
    
    
    //MARK : - Collectionview Delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  CollectnImages {
            return arrimages.count
        }else{
            return arrimages1.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell1 = UICollectionViewCell()
        if collectionView ==  CollectnImages{
            
           let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmntDetail", for: indexPath) as! AttachmntDetailCollectionViewCell
            cell.DetailImage.image = arrimages[indexPath.row]
            
            //cell.btn_left.layer .setValue(indexPath.row, forKey: "leftBtnIndex")
            //cell.btn_Right.layer .setValue(indexPath.row, forKey: "rightBtnIndex")
            //cell.btn_Right.addTarget(self, action: #selector(AttachmentDetailVC.btnPress_Right(_:)), for: UIControlEvents.touchUpInside)
            //cell.btn_Right.tag = indexPath.row
            //cell.btn_left.addTarget(self, action: #selector(AttachmentDetailVC.btnPress_Left), for: UIControlEvents.touchUpInside)
            
            return cell
        }
        if collectionView ==  collectionBottum{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottumCell", for: indexPath) as! BottumCell
            cell.imageView.image = arrimages1[indexPath.row]
            return cell
        }
        return cell1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    @IBAction func btnPress_Right(_ sender: UIButton)
    {
        //let btnRight = sender
        //var indexPathRight = btnRight.layer.value(forKey: "rightBtnIndex") as! Int
        
        if currentImageIndex < arrimages.count - 1 {
            currentImageIndex += 1
            
            var indexNewRight = NSIndexPath()
        
            //indexNewRight = NSIndexPath.init(index: indexPathRight)
            indexNewRight = IndexPath(row: currentImageIndex, section: 0) as NSIndexPath
            
            CollectnImages.scrollToItem(at: indexNewRight as IndexPath, at: UICollectionViewScrollPosition.right, animated: true)

        }
        
    }
    
    @IBAction func btnPress_Left(_ sender: AnyObject) {
        
        //let btnLeft = sender
        //var indexPathLeft = btnLeft.layer.value(forKey: "leftBtnIndex") as! Int
        
        if currentImageIndex > 0 {
            currentImageIndex -= 1
            var indexNewLeft = NSIndexPath()
            
           // indexNewLeft = NSIndexPath.init(index: indexPathLeft)
           indexNewLeft = IndexPath(row: currentImageIndex, section: 0) as NSIndexPath
            
            CollectnImages.scrollToItem(at: indexNewLeft as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
