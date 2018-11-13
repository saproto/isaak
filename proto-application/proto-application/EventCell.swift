//
//  EventCell.swift
//  proto-application
//
//  Created by Hessel Bierma on 10/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet var eventTime: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
