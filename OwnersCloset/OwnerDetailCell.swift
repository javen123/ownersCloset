//
//  OwnerDetailCell.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/14/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class OwnerDetailCell: UITableViewCell {

    
    
    var value:Int!
   
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
