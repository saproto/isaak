//
//  ProfileViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var profileVIew: UIView!
    @IBOutlet var welcomeMessageLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    var ppUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.layer.cornerRadius = 90
        profilePicture.layer.masksToBounds = true
        profileVIew.layer.cornerRadius = 100
        profileVIew.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
        let headers: HTTPHeaders = ["Authorization" : "Bearer " + keychain.get("access_token")!]
        
        let request = Alamofire.request(OAuth.profileInfo,
                          method: .get,
                          parameters: [:],
                          encoding: URLEncoding.methodDependent,
                          headers: headers)
        
        request.responseProfileInfo{ response in
            if let profileInfo = response.result.value {
                
                DispatchQueue.main.async {
                    self.welcomeMessageLbl.text = profileInfo.welcomeMessage
                    self.userNameLbl.text = profileInfo.name
                    Alamofire.request(profileInfo.photoPreview!).responseImage { response in
                        if let image = response.result.value{
                            DispatchQueue.main.async {
                                self.profilePicture.image = image
                            }
                        }
                    }
                }
            }
        }
    }

}
