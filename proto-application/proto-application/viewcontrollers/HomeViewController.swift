//
//  HomeViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

var headers: HTTPHeaders = ["Authorization" : "Bearer " + keychain.get("access_token")!]

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var newsTable: UITableView!
    var news: News = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(news.count)
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseNewsArticleCell") as! newsArticleCell
        cell.title.text = news[indexPath.row].title
        if ((news[indexPath.row].featuredImageURL ?? "").isEmpty){
            cell.title.textColor = UIColor.black
            cell.featuredImage.image = nil
        }else{
            cell.title.textColor = UIColor.white
            var url = news[indexPath.row].featuredImageURL!
            url = url.dropLast(3) + "400"
            Alamofire.request(url).responseImage{ response in
                if let image = response.result.value{
                    DispatchQueue.main.async {
                        cell.featuredImage.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toArticleDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! articleViewController
        dest.article = news[(newsTable.indexPathForSelectedRow?.row)!]
    }

    override func viewWillAppear(_ animated: Bool) {
        newsTable.rowHeight = 120
        getNews(completion: { completion in
            self.newsTable.reloadData()
        })
        retrieveProtubeToken()
    }
    
    func getNews(completion: @escaping (_ result: Bool) -> Void){
        let newsRequest = Alamofire.request(OAuth.news,
                                            method: .get,
                                            parameters: [:],
                                            encoding: URLEncoding.methodDependent,
                                            headers: [:])
        newsRequest.responseNews{ response in
            self.news = []
            let newsResp = response.result.value
            for i in 0 ... (newsResp?.count)! - 1{
                self.news.append(newsResp![i])
            }
            completion(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTable.dataSource = self
        newsTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
}
