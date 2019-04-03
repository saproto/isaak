//
//  ProtubeAdminViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 02/04/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//

import UIKit
import SocketIO
import Alamofire

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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchResultsTable.dataSource = self
        searchResultsTable.delegate = self
        searchResultsTable.rowHeight = 280
        retrieveProtubeToken()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchResultsTable.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func retrieveProtubeToken(){
        let protubeTokenReq = Alamofire.request(OAuth.protubeToken,
                                              method: .get,
                                              parameters: [:],
                                              encoding: URLEncoding.methodDependent,
                                              headers: OAuth.headers)
        protubeTokenReq.responseProtubeToken{ response in
            keychain.set(response.result.value!.token!, forKey: "protubeToken")
        }
    }
}
