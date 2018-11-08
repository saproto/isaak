//
//  CalendarViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var calHeight: NSLayoutConstraint!
    @IBOutlet var Calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little̵ preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0{
            calHeight.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else{
            calHeight.constant = 255
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
