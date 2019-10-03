//
//  PurchaseHistoryViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import Alamofire

class PurchaseHistoryViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var purchaseTable: UITableView!
    var orderlines: Orderline = []
    @IBOutlet var totalMonthLabel: UILabel!
    @IBOutlet var nextWithdrawalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseTable.dataSource = self
        //purchaseHistTable.rowHeight = 150
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderlines.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Purchases"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell") as! PurchaseCell
        
        cell.productName.text = orderlines[indexPath.row].product?.name
        cell.productPrice.text = "€" + String(format:"%.2f", orderlines[indexPath.row].totalPrice!)
        cell.purchaseTime.text = orderlines[indexPath.row].createdAt
        cell.nrOfUnits.text = String(orderlines[indexPath.row].units!) + "x"
        cell.unitPrice.text = "€" + String(format:"%.2f", orderlines[indexPath.row].originalUnitPrice!)
        
        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let totalMonthReq = Alamofire.request(OAuth.total_month,
                                              method: .get,
                                              parameters: [:],
                                              encoding: URLEncoding.methodDependent,
                                              headers: OAuth.headers)
        totalMonthReq.responseJSON{response in
            switch response.result{
            case .success:
                DispatchQueue.main.async {
                    let amount: Double = response.result.value! as! Double
                    self.totalMonthLabel.text = "€" + String(format: "%.2f", amount)
                }
            case .failure:
                print("total month failed")
                print(response.result)
            }
        }
        
        let nextWithdrawalReq = Alamofire.request(OAuth.next_withdrawal,
                                                  method: .get,
                                                  parameters: [:],
                                                  encoding: URLEncoding.methodDependent,
                                                  headers: OAuth.headers)
        nextWithdrawalReq.responseJSON{response in
            switch response.result{
            case .success:
                DispatchQueue.main.async {
                    let amount: Double = response.result.value! as! Double
                    self.nextWithdrawalLabel.text = "€" + String(format: "%.2f", amount)
                }
            case .failure:
                print("next withdrawal failed")
                print(response.result)
            }
        }
        
        let orderlinesReq = Alamofire.request(OAuth.orderlines,
                                              method: .get,
                                              parameters: [:],
                                              encoding: URLEncoding.methodDependent,
                                              headers: OAuth.headers)
        orderlinesReq.responseOrderline{ response in
            switch response.result{
            case .success:
                self.orderlines = response.result.value!
                self.purchaseTable.reloadData()
            case .failure:
                print("orderlines failed")
            }
        }
        
    }
}
