//
//  CalendarViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var calHeight: NSLayoutConstraint!
    @IBOutlet var Calendar: FSCalendar!
    @IBOutlet var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.rowHeight = 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section " + String(section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventCell
        
        cell.eventTitle.text = "Javascript workshop"
        cell.eventTime.text = "14:35"
        cell.eventLocation.text = "Spiegel"
        
        return cell
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
