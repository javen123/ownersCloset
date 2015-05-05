//
//  ItemCell.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/1/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var imageBool: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
