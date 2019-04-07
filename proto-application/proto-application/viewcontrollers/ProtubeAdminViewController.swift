//
//  ProtubeAdminViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 02/04/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//

import UIKit
import SocketIO

class ProtubeAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchResultsTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ytVideoCell") as! ytVideoCell
        
        cell.artist.text = "AdeleVEVO"
        cell.duration.text = "06:07"
        cell.title.text = "Adele - Hello"
        cell.thumbnailURL = "YQHsXMglC9A"
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchResultsTable.dataSource = self
        searchResultsTable.delegate = self
        searchResultsTable.rowHeight = 275
        addHandlers()
        
        protube.on("authenticated"){ data, ack in
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchResultsTable.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "backToProfile", sender: nil)
    }
    
    func addHandlers(){
        
    }
}
