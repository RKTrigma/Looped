//
//  newgroupCell.swift
//  looped
//
//  Created by Nitin Suri on 23/11/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class newgroupCell: UITableViewCell {

    // MARK: OUTLETS
    
    @IBOutlet var imageUser: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblDesignation: UILabel!
    
    @IBOutlet var lblTeamCountry: UILabel!
    
    @IBOutlet var btnDeleteOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
