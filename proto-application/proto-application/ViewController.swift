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
            consumerKey:    OAuth.consumerKey,
            consumerSecret: OAuth.consumerSecret,
            authorizeUrl:   OAuth.authorizeURL,
            accessTokenUrl: OAuth.accesTokenURL,
            responseType:   "code"
        )
        
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        
        guard let rwURL = URL(string: "saproto://") else { return }
        
        oauthswift.authorize(withCallbackURL: rwURL, scope: "*", state: "", success: { (credential, response, parameters) in
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }, failure: { (error) in
            //self.presentAlert("Error", message: error.localizedDescription)
            print(error)
        })
        
        
        
        self.performSegue(withIdentifier: "toHome", sender: nil)
        
    }
    
}
