//
//  CallsTabBarVC.swift
//  looped
//
//  Created by Raman Kant on 12/1/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class CallsTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.selectedIndex  = 0
        let itemWidth       = self.view.frame.size.width/3
        let itemHeight      = self.tabBar.frame.size.height
        
        let favouriteBtn = UIButton(frame: CGRect(x: itemWidth * 0.0, y: self.view.frame.size.height - itemHeight , width: itemWidth, height: itemHeight))
        favouriteBtn.setBackgroundImage(UIImage(named: "people_tab_unselected"), for: UIControlState.normal)
        favouriteBtn.setBackgroundImage(UIImage(named: "people_tab_selected"), for: UIControlState.selected)
        favouriteBtn.adjustsImageWhenHighlighted = false
        favouriteBtn.addTarget(self, action: #selector(commonMethod), for: UIControlEvents.touchUpInside)
        favouriteBtn.tag        = 1
        favouriteBtn.isSelected = true
        self.view.addSubview(favouriteBtn)
        
        let editBtn = UIButton(frame: CGRect(x: itemWidth * 1.0, y: self.view.frame.size.height - itemHeight , width: itemWidth, height: itemHeight))
        editBtn.setBackgroundImage(UIImage(named: "favorite_tab_unselected"), for: UIControlState.normal)
        editBtn.setBackgroundImage(UIImage(named: "favorite_tab_selected"), for: UIControlState.selected)
        editBtn.adjustsImageWhenHighlighted = false
        editBtn.addTarget(self, action: #selector(commonMethod), for: UIControlEvents.touchUpInside)
        editBtn.tag = 2
        self.view.addSubview(editBtn)
        
        let attachBtn = UIButton(frame: CGRect(x: itemWidth * 2.0, y: self.view.frame.size.height - itemHeight , width: itemWidth, height: itemHeight))
        attachBtn.setBackgroundImage(UIImage(named: "call_history_tab_unselected"), for: UIControlState.normal)
        attachBtn.setBackgroundImage(UIImage(named: "call_history_tab_selected"), for: UIControlState.selected)
        attachBtn.adjustsImageWhenHighlighted = false
        attachBtn.addTarget(self, action: #selector(commonMethod), for: UIControlEvents.touchUpInside)
        attachBtn.tag = 3
        self.view.addSubview(attachBtn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commonMethod ( sender : UIButton){
        
        for i in 1..<4 {
            let button = self.view.viewWithTag(i) as! UIButton
            if (sender as AnyObject).tag == i {
                button.isSelected   = true
                self.selectedIndex  = i - 1
            }else{
                button.isSelected   = false
            }
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

}
