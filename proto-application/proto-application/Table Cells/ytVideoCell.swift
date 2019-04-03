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

    var thumbnailURL: String = String()
    @IBOutlet var Thumbnail: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var artist: UILabel!
    @IBOutlet var duration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let thumbnailReq = Alamofire.request("https://img.youtube.com/vi/" + thumbnailURL + "/0.jpg")
        thumbnailReq.responseImage{ response in
            DispatchQueue.main.async{
                if let image = response.result.value{
                    self.Thumbnail.image = image
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
