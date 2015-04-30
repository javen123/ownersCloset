//
//  OwnerVCCell.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/14/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class OwnerVCCell: UITableViewCell {

    @IBOutlet weak var ownResName: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
