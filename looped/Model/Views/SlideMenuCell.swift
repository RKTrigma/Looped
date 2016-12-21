//
//  SlideMenuCell.swift
//  looped
//
//  Created by Nitin Suri on 23/11/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class SlideMenuCell: UITableViewCell {
    
    // MARK: OUTLETS
    
    @IBOutlet var lblMenuTitle: UILabel!
    @IBOutlet var imageMenu: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
