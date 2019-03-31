//
//  newsArticleCell.swift
//  proto-application
//
//  Created by Hessel Bierma on 30/03/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//

import UIKit

class newsArticleCell: UITableViewCell {

    @IBOutlet var featuredImage: UIImageView!
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
