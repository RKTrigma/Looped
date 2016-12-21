//
//  CallHistoryViewCell.swift
//  looped
//
//  Created by Nitin Suri on 19/11/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class CallHistoryViewCell: UITableViewCell {
    
    @IBOutlet var viewRedTopLine: UIView!
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblDesignation: UILabel!
    @IBOutlet var lblDate: UILabel!

    @IBOutlet var lblTeam: UILabel!
    
    @IBOutlet var viewFooterBG: UIView!
    
    @IBOutlet var btnHistoryOutlet: UIButton!
    
    @IBOutlet var btnMessageOutlet: UIButton!
    
    @IBOutlet var btncallOutlet: UIButton!
    
    @IBOutlet var btnVideoCallOutelt: UIButton!
    
    @IBOutlet var btnAddToFavOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
