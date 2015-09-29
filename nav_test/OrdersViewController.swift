//
//  OrdersViewController.swift
//  nav_test
//
//  Created by Computer on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Alamofire

class OrdersViewController: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderProgressBar: UIProgressView!
    @IBOutlet weak var dispensaryLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var ordersTable: UITableView!
    
    var orders = Array<String>()
    var prices = Array<String>()
    var email = String()
    var id = String()
    var orderId = String()
    //    var currentUser = Array<NSDictionary>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("orders view")
        ordersTable.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        getCurrentUser()
        print("got the current user")
        getOrder()
        print("Got the orders")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if orders.count > 0 {
            orderStatusLabel.hidden = false
            orderProgressBar.hidden = false
            dispensaryLabel.hidden = false
            cancelButton.hidden = false
            ordersTable.hidden = false
        } else {
            getOrder()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell") as! OrderCell
        let order = orders[0]
        let price = prices[0]
        cell.strainLabel.text = order
        cell.priceLabel.text = price
        return cell
    }
    
    func getCurrentUser() {
        let string = "http://lithubb.herokuapp.com/currentUser"
        Alamofire.request(.GET, string)
            .responseJSON { request, response, result in switch result {
                    case .Success(let data):
                        print("Checked for user, success", data)
                        let user = JSON(data)
                        let userEmail = user[0]["email"]
                        let userId = user[0]["id"]
                        self.email = String(userEmail)
                        self.id = String(userId)
                    case .Failure(_, let error):
                        print("There was an error getting your user information")
                }
            }
//        // gets current user email and id
//        let string: "http://192.168.1.146:7000/currentUser") {
//            if let data = NSData(contentsOfURL: urlToReq) {
//                //This JSON function is from SwiftyJason and parses the JSON data.
//                let user = JSON(data: data)
//                let userEmail = user["email"]
//                let userId = user["id"]
//                email = String(userEmail)
//                id = String(userId)
//            }
//        }
    }
    
    @IBAction func cancelOrder(sender: UIButton) {
        if let urlToReq = NSURL(string: "http://lithubb.herokuapp.com/cancelOrder"){
            let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "id=\(Int(orderId)!)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response, data, error) in
                let realasdfData = JSON(data: data!)
                print(realasdfData)
            }
            self.orderStatusLabel.hidden = true
            self.ordersTable.hidden = true
            self.orderProgressBar.hidden = true
            self.cancelButton.hidden = true
            self.orderNumberLabel.text = "Your order has been canceled"
            self.dispensaryLabel.text = "Thank you"
        }
    }
    
    func getOrder() {
        //Alamofire getting the orders
        let string = "http://lithubb.herokuapp.com/getReservations"
        Alamofire.request(.POST, string)
            .responseJSON { request, response, result in switch result {
            //success case
            case .Success(let data):
                print("Checked for user, success", data)
                let orders = JSON(data)
                print("Here are the orders", orders)
                if orders.count != 0 {
                    self.orderNumberLabel.text = String(orders[0]["status"])
                    self.orderId = String(orders[0]["id"])
                    //progress bar
                    switch String(orders[0]["status"]) {
                    case "0":
                        self.orderStatusLabel.text = "pending..."
                        self.orderProgressBar.progress = 0.1
                    case "1":
                        self.orderStatusLabel.text = "processing"
                        self.orderProgressBar.progress = 0.5
                    case "2":
                        self.orderStatusLabel.text = "shipped"
                        self.orderProgressBar.progress = 1.0
                    default:
                        self.orderStatusLabel.text = "error"
                    }
                    //Order Number
                    let OrderNumberToPass = String(orders[0]["id"])
                    self.orderNumberLabel.text = "Order Number: \(OrderNumberToPass)"
                    //Vendor (we need to trip the whitespace. That's weird stuff)
                    let vendor = String(orders[0]["vendor"])
                    let vendorToPass = vendor.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    self.dispensaryLabel.text = vendorToPass
                    //this is for if we later on allow more than one strain. That's why it's in a for loop.
                    if self.orders.count == 0 {
                        self.orders.append(String(orders[0]["name"]))
                        self.ordersTable.reloadData()
                    }
                    //this price is not ready for more strains
                    if self.prices.count == 0 {
                        if String(orders[0]["quantity_half"]) == "1" {
                            let priceToPass = String(Double(String(orders[0]["price_gram"]))! * Double(14.15))
                            self.prices.append("(priceToPass")
                            self.ordersTable.reloadData()
                        } else if String(orders[0]["quantity_eigth"]) == "1" {
                            let priceToPass = String(Double(String(orders[0]["price_gram"]))! * Double(3.54))
                            self.prices.append(priceToPass)
                            self.ordersTable.reloadData()
                        } else if String(orders[0]["quantity_gram"]) == "1" {
                            let priceToPass = String(Double(String(orders[0]["price_gram"]))!)
                            self.prices.append(priceToPass)
                            self.ordersTable.reloadData()
                        } else if String(orders[0]["quantity_oz"]) == "1" {
                            let priceToPass = String(Double(String(orders[0]["price_gram"]))! * Double(28.29))
                            self.prices.append(priceToPass)
                            self.ordersTable.reloadData()
                        }
                    }
                } else {
                    self.orderStatusLabel.hidden = false
                    self.ordersTable.hidden = true
                    self.orderProgressBar.hidden = true
                    self.cancelButton.hidden = true
                    self.orderNumberLabel.hidden = true
                    self.dispensaryLabel.hidden = true
                    self.orderStatusLabel.text = "You have no orders"
                }
                
            //failure case
            case .Failure(_, let error):
                print("There was an error getting your order information")
            }
        }
    }
}
