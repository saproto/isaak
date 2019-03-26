//
//  EventDetailViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 20/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet var eventTitleLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var startTimeLbl: UILabel!
    @IBOutlet var endTimeLbl: UILabel!
    @IBOutlet var descriptionText: UITextView!
    
    var events: Event = []
    var eventNr: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitleLbl.text = events[eventNr].title
        locationLbl.text = events[eventNr].location
        startTimeLbl.text = Date(timeIntervalSince1970: events[eventNr].start!).readableString()
        endTimeLbl.text = Date(timeIntervalSince1970: events[eventNr].end!).readableString()
        descriptionText.text = events[eventNr].description
        // Do any additional setup after loading the view.
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

}
