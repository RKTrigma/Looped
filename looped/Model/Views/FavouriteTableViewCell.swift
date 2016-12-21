//
//  FavouriteTableViewCell.swift
//  looped
//
//  Created by Divya Khanna on 11/10/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
// MARK: - Outlets
    
    @IBOutlet var UserImg: UIImageView!
    
    @IBOutlet var ChatActiveImg: UIImageView!
    
    @IBOutlet var NameLabel: UILabel!
    
    @IBOutlet var PositionLabel: UILabel!
    
    @IBOutlet var CountryLabel: UILabel!
    
    @IBOutlet var btnDeleteUser: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
