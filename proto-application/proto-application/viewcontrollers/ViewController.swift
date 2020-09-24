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
import CoreData

var container : NSPersistentContainer!

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    

    var webAuthSession: ASWebAuthenticationSession?
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBAction func unwindToLogInView(segue: UIStoryboardSegue){}
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loggedInLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loggedInLbl.text = ""
        activityIndicator.isHidden = true //hide activity Indicator
        
        if !(keychain.get("access_token") ?? "").isEmpty{
            print(keychain.get("access_token")!)
            //loggedInLbl.text = "Welcome, " + keychain.get("calling_name")!
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            loginButton.isHidden = true
            tryAccessToken(completion: {completion in
                if completion{
                    print("checked, still active")
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                }else{
                    refreshToken(completion: { completion in
                        if completion{
                            self.performSegue(withIdentifier: "toHome", sender: nil)
                            print("checked, refreshed token")
                        }else{
                            // #TODO: show alert that they have to log in again
                            self.activityIndicator.isHidden = true
                            self.loggedInLbl.text = ""
                            self.loginButton.isHidden = false
                            print("checked, tried to refresh but failed.")
                        }
                    })
                }
            })
        }else{
            loginButton.isHidden = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if isLoggedIn(){
//            self.performSegue(withIdentifier: "toHome", sender: nil)
//        }
    }

    @IBAction func LogInPressed(_ sender: UIButton) {
        
        activityIndicator.isHidden = false //when user presses login, start activity indicator
        activityIndicator.startAnimating()
        
        let oauthUrl = URL(string: OAuth.authorizeURL) //initialization of ASWebAuthenticationSession
        let callbackURL = OAuth.callbackURL
        
        print(oauthUrl)
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: oauthUrl!, callbackURLScheme: callbackURL, completionHandler: { (callBack:URL?, error:Error?) in
            guard error == nil, let successURL = callBack else {
                print(error?.localizedDescription)
                return
            }
            
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first //extract token from callback URL
            print(oauthToken!)
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
        if #available(iOS 13.0, *) {
            self.webAuthSession?.presentationContextProvider = self
        } else {
            // Fallback on earlier versions
        }
        self.webAuthSession?.start() //execute the webauthenticationsession
        
    }
}
