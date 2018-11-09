//
//  ViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 16/10/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func LogInPressed(_ sender: UIButton) {
        
        let oauthswift = OAuth2Swift(
            consumerKey:    "*********",
            consumerSecret: "*********",        // No secret required
            authorizeUrl:   "https://proto.utwente.nl/oauth/authorize",
            accessTokenUrl: "https://proto.utwente.nl/oauth/token",
            responseType:   "code"
        )
        
        oauthswift.allowMissingStateCheck = true
        //2
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        
        guard let rwURL = URL(string: "saproto://oauth_callback") else { return }
        
        oauthswift.authorize(withCallbackURL: rwURL, scope: "*", state: "", success: { (credential, response, parameters) in
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }, failure: { (error) in
            //self.presentAlert("Error", message: error.localizedDescription)
        })
        
        
        
        
    }
    
}

