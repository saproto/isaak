//
//  ViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 16/10/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import OAuthSwift
import AuthenticationServices

class ViewController: UIViewController {

    var webAuthSession: ASWebAuthenticationSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func LogInPressed(_ sender: UIButton) {
        
        let oauthUrl = URL(string: OAuth.authorizeURL)
        let callbackURL = OAuth.callbackURL
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: oauthUrl!, callbackURLScheme: callbackURL, completionHandler: { (callBack:URL?, error:Error?) in
            
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            
            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
            
            
            
        })
        
        self.webAuthSession?.start()
        
        //self.performSegue(withIdentifier: "toHome", sender: nil)
        
        
    }
    
}