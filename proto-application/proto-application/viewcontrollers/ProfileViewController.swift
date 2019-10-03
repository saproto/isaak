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
    @IBAction func unwindToProfileView(segue: UIStoryboardSegue){}
    var ppUrl: String!
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewDidLoad()
        profilePicture.layer.cornerRadius = 90
        profilePicture.layer.masksToBounds = true
        profileVIew.layer.cornerRadius = 100
        profileVIew.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
        let request = Alamofire.request(OAuth.profileInfo,
                          method: .get,
                          parameters: [:],
                          encoding: URLEncoding.methodDependent,
                          headers: OAuth.headers)
        
        request.responseProfileInfo{ response in
            if let profileInfo = response.result.value {
                
                DispatchQueue.main.async {
                    self.welcomeMessageLbl.text = profileInfo.welcomeMessage
                    self.userNameLbl.text = profileInfo.name
                }
            }
        }
        
        let profPictureReq = Alamofire.request(OAuth.profilePicture,
                                               method: .get,
                                               parameters: [:],
                                               encoding: URLEncoding.methodDependent,
                                               headers: OAuth.headers)
        
        profPictureReq.responseProfilePicture{ response in
            print(response)
            if let profilePic = response.result.value{
                print(profilePic.m!)
                Alamofire.request(profilePic.m!).responseImage { response2 in
                    if let image = response2.result.value{
                        DispatchQueue.main.async {
                            self.profilePicture.image = image
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func payOmnomcomPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toPayOmnomcom", sender: nil)
    }
    
    @IBAction func protubeAdminPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showPinInput", sender: nil)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        keychain.clear()
        self.performSegue(withIdentifier: "unwindToLogIn", sender: nil)
    }
}
