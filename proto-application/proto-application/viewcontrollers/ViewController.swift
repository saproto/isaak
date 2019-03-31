//
//  ViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 16/10/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import AuthenticationServices
import Alamofire
import KeychainSwift

class ViewController: UIViewController {

    var webAuthSession: ASWebAuthenticationSession?
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBAction func unwindToLogInView(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(KeychainWrapper.standard.string(forKey: "access_token")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = true //hide activity Indicator
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoggedIn(){
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }
    }

    @IBAction func LogInPressed(_ sender: UIButton) {
        
        activityIndicator.isHidden = false //when user presses login, start activity indicator
        activityIndicator.startAnimating()
        
        let oauthUrl = URL(string: OAuth.authorizeURL) //initialization of ASWebAuthenticationSession
        let callbackURL = OAuth.callbackURL
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: oauthUrl!, callbackURLScheme: callbackURL, completionHandler: { (callBack:URL?, error:Error?) in
            guard error == nil, let successURL = callBack else {return}
            
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first //extract token from callback URL
            
            tokenRequest(token: oauthToken?.value as Any, completion: {completion in
                if completion{
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                    self.activityIndicator.stopAnimating()
                }else{
                    let alert = UIAlertController(title: "Failed Authentication", message: "Your authentication failed, please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    self.activityIndicator.stopAnimating()
                }
            })
        })
        self.webAuthSession?.start() //execute the webauthenticationsession
        
    }
}
