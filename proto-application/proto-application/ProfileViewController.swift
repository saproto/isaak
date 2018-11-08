//
//  ProfileViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var profileVIew: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.layer.cornerRadius = 90
        profilePicture.layer.masksToBounds = true
        profileVIew.layer.cornerRadius = 100
        profileVIew.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
