//
//  DialogsCell.swift
//  looped
//
//  Created by Raman Kant on 11/7/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class DialogsCell: UITableViewCell {

    @IBOutlet var chatactiveonline: UIImageView!
    
    @IBOutlet var imageViewDialog         : UIImageView!
    @IBOutlet var labelDialogTitle        : UILabel!
    @IBOutlet var labelDialogSubtitle     : UILabel!
    @IBOutlet var labelBadgeCount         : UILabel!
    @IBOutlet var lblDelTimeStamp: UILabel!

    @IBOutlet var lbltitle2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
