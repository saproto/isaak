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
    var events: Event = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.rowHeight = 100
        Calendar.delegate = self
        Calendar.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventCell
        
        cell.eventTitle.text = events[indexPath.row].title
        cell.eventTime.text = Date(timeIntervalSince1970: events[indexPath.row].start!).readableString()
        cell.eventLocation.text = events[indexPath.row].location
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowEventDetail", sender: nil)
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EventDetailViewController{
            let destVC = segue.destination as! EventDetailViewController
            destVC.events = events
            destVC.eventNr = eventTableView.indexPathForSelectedRow!.row
        }
    }
    
    func EventRequest(fromDate: Double, onlySubscribed: Bool){
        
        let headers: HTTPHeaders = ["Authorization" : "Bearer " + keychain.get("access_token")!]
        
        let eventsRequest = Alamofire.request(OAuth.upcomingEvents,
                                            method: .get,
                                            parameters: [:],
                                            encoding: URLEncoding.methodDependent,
                                            headers: headers)
        eventsRequest.responseEvent { response in
            print("response: ")
            print(response)
            self.events = []
            
            let eventsResp = response.result.value
            for i in 0 ... (eventsResp?.count)! - 1{
                if eventsResp![i].start! >= fromDate{
                    self.events.append(eventsResp![i])
                }
            }
            print(self.events.count)
            self.eventTableView.reloadData()
        }
    }
}


