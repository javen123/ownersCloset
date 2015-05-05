//
//  OwnerItemDetailCell.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/4/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class OwnerItemDetailCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var slider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
