//
//  articleViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 30/03/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Down

class articleViewController: UIViewController {

    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var content: UITextView!
    @IBOutlet var releaseDate: UILabel!
    
    var article: NewsElement = NewsElement.init(id: nil, title: nil, featuredImageURL: nil, content: nil, publishedAt: nil)
    var releaseDateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTitle.text = article.title
        
        releaseDateFormat.dateStyle = .long
        releaseDateFormat.timeStyle = .none
        releaseDate.text = releaseDateFormat.string(from: Date(timeIntervalSince1970: article.publishedAt!))
        
        if !((article.featuredImageURL ?? "").isEmpty){
            Alamofire.request(article.featuredImageURL!).responseImage{ response in
                if let image = response.result.value{
                    DispatchQueue.main.async {
                        self.headerImage.image = image
                    }
                }
            }
        }
        let down = Down(markdownString: article.content!)
        let articleText = try? down.toAttributedString()
        content.attributedText = articleText
        content.textColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    @IBAction func screenEdgeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
