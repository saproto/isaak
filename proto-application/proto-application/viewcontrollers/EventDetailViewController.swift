//
//  EventDetailViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 20/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import Down
import Alamofire

class EventDetailViewController: UIViewController {
    
    @IBOutlet var eventTitleLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var startTimeLbl: UILabel!
    @IBOutlet var endTimeLbl: UILabel!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var SignupBtn: UIButton!
    
    //var events: Event = []
    var eventID: Int = 0
    var event = events[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshBtn()
        
        eventTitleLbl.text = event.title
        locationLbl.text = event.location
        startTimeLbl.text = Date(timeIntervalSince1970: event.start!).readableString()
        endTimeLbl.text = Date(timeIntervalSince1970: event.end!).readableString()
        
        let down = Down(markdownString: event.eventDescription!) //create markdown entity
        let descriptionString = try? down.toAttributedString() //convert markdown to attributed string
        descriptionText.attributedText = descriptionString //make the textView display the markdown text.
        descriptionText.textColor = UIColor.white
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        if event.userSignedup! && event.canSignout! {
            signOut(participation_id: event.userSignedupID!, completion: {completion in
                if completion{

                    let controller = UIAlertController(title: "Success!", message: "You successfully signed out for this event", preferredStyle: .alert)
                    let Yes = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
                
                    controller.addAction(Yes)
                
                    self.present(controller, animated: true, completion: nil)
                    self.refreshBtn()
                }else{
                    let controller = UIAlertController(title: "Failed", message: "Signing you out failed", preferredStyle: .alert)
                    let Yes = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
                    
                    controller.addAction(Yes)
                    
                    self.present(controller, animated: true, completion: nil)
                }
            })
        }
        if !event.userSignedup! && event.canSignup! && event.hasSignup! {
            signUp(activity_id: event.id!, completion: {completion in
                if completion{

                    let controller = UIAlertController(title: "Success!", message: "You successfully signed up for this event", preferredStyle: .alert)
                    let Yes = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
                    
                    controller.addAction(Yes)
                    
                    self.present(controller, animated: true, completion: nil)
                    self.refreshBtn()
                }else{
                    let controller = UIAlertController(title: "Failed", message: "Signing up failed", preferredStyle: .alert)
                    let Yes = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
                    
                    controller.addAction(Yes)
                    
                    self.present(controller, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func exitPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func signOut(participation_id: Int, completion: @escaping (_ result: Bool) -> Void){
        let req = Alamofire.request(OAuth.signout + String(participation_id),
                                    method: .get,
                                    parameters: [:],
                                    encoding: URLEncoding.methodDependent,
                                    headers: OAuth.headers)
        req.responseJSON{response in
            switch response.result{
            case .success:
                refreshEvents()
                completion(true)
                print(response.result.value!)
            case .failure:
                completion(false)
                print(response.result)
            }
        }
    }
    
    func signUp(activity_id: Int, completion: @escaping (_ result: Bool) -> Void){
        let req = Alamofire.request(OAuth.signup + String(activity_id),
                                    method: .get,
                                    parameters: [:],
                                    encoding: URLEncoding.methodDependent,
                                    headers: OAuth.headers)
        req.responseJSON{response in
            switch response.result{
            case .success:
                refreshEvents()
                completion(true)
                print(response.result.value!)
            case .failure:
                completion(false)
                print(response.result)
            }
        }
    }
    
    func refreshBtn(){
        for i in 0 ... events.count - 1{
            if events[i].id == eventID{
                event = events[i]
                break
            }
        }
        
        SignupBtn.isHidden = !(event.hasSignup ?? false)
        
        if !SignupBtn.isHidden{
            if event.userSignedup ?? false{
                if event.canSignout! {
                    //signed up and can still sign out
                    SignupBtn.setTitle("Sign me out", for: .normal)
                    SignupBtn.backgroundColor = UIColor.red
                }else{
                    //signed up, but cannot sign out
                    SignupBtn.isEnabled = false
                    SignupBtn.backgroundColor = UIColor.gray
                    SignupBtn.setTitle("You cannot sign out", for: .normal)
                }
            }else{
                if event.canSignup!{
                    //can sign up, but is not yet signed up
                    let btntext = "Sign me up | €" + String(format:"%.2f", event.price!)
                    print(btntext)
                    SignupBtn.setTitle(btntext, for: .normal)
                    SignupBtn.backgroundColor = pSiteBlue
                }else{
                    //cannot sign in
                    SignupBtn.isEnabled = false
                    SignupBtn.backgroundColor = UIColor.gray
                    SignupBtn.setTitle("You cannot sign up", for: .normal)
                }
            }
        }
    }
}
