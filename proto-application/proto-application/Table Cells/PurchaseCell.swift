//
//  PurchaseCell.swift
//  proto-application
//
//  Created by Hessel Bierma on 11/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit

class PurchaseCell: UITableViewCell {

    @IBOutlet var productPrice: UILabel!
    @IBOutlet var purchaseTime: UILabel!
    @IBOutlet var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
