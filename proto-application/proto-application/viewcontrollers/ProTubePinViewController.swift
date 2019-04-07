//
//  ProTubePinViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 03/04/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//

import UIKit
import SocketIO
import Alamofire

let manager = SocketManager(socketURL: URL(string: "wss://metis.proto.utwente.nl:3001")!, config: [.log(true)])
let protube = manager.defaultSocket

class ProTubePinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var digit1: UITextField!
    @IBOutlet var digit2: UITextField!
    @IBOutlet var digit3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        protube.connect()
        print("connect socket")
        digit1.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        protube.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            protube.emit("token", keychain.get("protube_token")!)
        }
        //protube.emit("token", keychain.get("protube_token")!)
        //print("tried to emit token")
        //print(keychain.get("protube_token")!)
        protube.on("authenticated"){ data, ack in
            self.performSegue(withIdentifier: "toPTRemote", sender: nil)
        }
    }
    
    @IBAction func digit1EditingChanged(_ sender: UITextField) {
        if digit1.text!.count == 1{
            digit2.becomeFirstResponder()
        }else if digit1.text!.count > 1{
            digit1.text = String((digit1.text?.prefix(0))!)
            digit2.becomeFirstResponder()
        }
    }
    
    @IBAction func digit2EditingChanged(_ sender: UITextField) {
        if digit2.text!.count == 1{
            digit3.becomeFirstResponder()
        }else if digit2.text!.count > 1{
            digit2.text = String((digit2.text?.prefix(0))!)
            digit3.becomeFirstResponder()
        }
    }
    
    @IBAction func digit3EditingChanged(_ sender: UITextField) {
        if digit3.text!.count == 1{
            digit1.isUserInteractionEnabled = false
            digit2.isUserInteractionEnabled = false
            digit3.isUserInteractionEnabled = false
            tryPinCode()
        }else if digit3.text!.count > 1{
            digit1.text = String((digit1.text?.prefix(0))!)
        }
    }
    
    func tryPinCode(){
        
        let pin = digit1.text! + digit2.text! + digit3.text!
        print(pin)
        let pinMes = "{\"pin\", \(pin)}"
        print(pinMes)
        
        protube.emit("pin", pinMes)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
