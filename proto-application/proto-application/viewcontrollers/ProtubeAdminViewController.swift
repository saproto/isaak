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
import AlamofireImage

class ProtubeAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchResultsTable: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchText: UITextField!
    @IBOutlet var showVideoSelector: UISegmentedControl!
    
    var results : [NSMutableDictionary] = []
    
    typealias SearchResult = [SearchResultElement]
    
    struct SearchResultElement: Codable {
        let id, title, channelTitle, duration: String?
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ytVideoCell") as! ytVideoCell
        
        cell.artist.text = results[indexPath.row].object(forKey: "channelTitle") as? String
        cell.duration.text = results[indexPath.row].object(forKey: "duration") as? String
        cell.title.text = results[indexPath.row].object(forKey: "title") as? String
        
        let thumbnailReq = Alamofire.request("https://img.youtube.com/vi/" + (results[indexPath.row].object(forKey: "id") as! String) + "/0.jpg")
        thumbnailReq.responseImage{ response in
            DispatchQueue.main.async{
                if let image = response.result.value{
                    cell.Thumbnail.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        protube.emit("add", ["id" : results[indexPath.row].object(forKey: "id")!, "showVideo" :  showVideo()])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchResultsTable.dataSource = self
        searchResultsTable.delegate = self
        searchResultsTable.rowHeight = 275
        addHandlers()

    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchText.resignFirstResponder()
        if !searchText.text!.isEmpty{
            activityIndicator.startAnimating()
            protube.emit("search", searchText.text!)
        }else{
            let controller = UIAlertController(title: "Search field is empty", message: "Please fill in a search term", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(ok)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        protube.disconnect()
        self.performSegue(withIdentifier: "backToProfile", sender: nil)
    }
    
    func addHandlers(){
        protube.on("searchResults", callback: { data, _ in
            self.activityIndicator.stopAnimating()
            let dataArray = data as NSArray
            let mutable = dataArray[0] as! NSMutableArray
            self.results = mutable as! [NSMutableDictionary]
            self.searchResultsTable.reloadData()
        })
    }
    
    func showVideo() -> Bool{
        if showVideoSelector.selectedSegmentIndex == 1{
            return true
        }else{
            return false
        }
    }
}
