//
//  PurchaseHistoryViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit

class PurchaseHistoryViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var purchaseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseTable.dataSource = self
        //purchaseHistTable.rowHeight = 150
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section " + String(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell") as! PurchaseCell
        
        cell.productName.text = "Snickers"
        cell.productPrice.text = "€0.50"
        cell.purchaseTime.text = "14:28:15"
        
        return cell
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
