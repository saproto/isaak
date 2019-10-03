//
//  CalendarViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import Alamofire

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var calHeight: NSLayoutConstraint!
    @IBOutlet var Calendar: FSCalendar!
    @IBOutlet var eventTableView: UITableView!
    var eventSelection : Event = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.rowHeight = 100
        Calendar.delegate = self
        Calendar.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        EventRequest(fromDate: NSDate().timeIntervalSince1970, onlySubscribed: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "section " + String(section)
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        EventRequest(fromDate: date.timeIntervalSince1970, onlySubscribed: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventSelection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventCell
        
        cell.eventTitle.text = eventSelection[indexPath.row].title
        cell.eventTime.text = Date(timeIntervalSince1970: eventSelection[indexPath.row].start!).readableString()
        cell.eventLocation.text = eventSelection[indexPath.row].location
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowEventDetail", sender: nil)
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0{
            EventRequest(fromDate: Date().timeIntervalSince1970, onlySubscribed: true)
        }else{
            EventRequest(fromDate: Calendar.selectedDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, onlySubscribed: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EventDetailViewController{
            let destVC = segue.destination as! EventDetailViewController
            //destVC.events = eventSelection
            destVC.eventID = eventSelection[eventTableView.indexPathForSelectedRow!.row].id!
        }
    }
    
    func EventRequest(fromDate: Double, onlySubscribed: Bool){
        
        eventSelection = [] //empty the array before filling it with a new selection
        
        for i in 0 ... (events.count) - 1{
            if events[i].start! >= fromDate{
                if onlySubscribed{
                    if events[i].userSignedup ?? false{
                        eventSelection.append(events[i])
                    }
                }else{
                    eventSelection.append(events[i])
                    
                }
            }
        }
        
        self.eventTableView.reloadData()
    }
}


