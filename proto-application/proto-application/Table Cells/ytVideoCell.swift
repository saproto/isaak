//
//  ytVideoCell.swift
//  proto-application
//
//  Created by Hessel Bierma on 03/04/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ytVideoCell: UITableViewCell {

    var thumbnailURL: String = ""
    @IBOutlet var Thumbnail: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var artist: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var plusImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
