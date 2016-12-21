//
//  ComposeMessageTableViewCell.swift
//  looped
//
//  Created by Divya Khanna on 11/9/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class ComposeMessageTableViewCell: UITableViewCell {
// MARK: - Outlets
    
    @IBOutlet var UserImg: UIImageView!
    
    @IBOutlet var LabelName: UILabel!
    
    @IBOutlet var LabelPosition: UILabel!
    
    @IBOutlet var LabelLocation: UILabel!
    
    @IBOutlet var imgChatonline: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
