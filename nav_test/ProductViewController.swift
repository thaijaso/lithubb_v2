//
//  ProductViewController.swift
//  nav_test
//
//  Created by mac on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Alamofire

class ProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var menuItem: Menu!
    var amountSelectedData = [String]()
    var email : String?
    var currentUserId : String?
    
    
    @IBOutlet weak var productName: UINavigationItem!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var indicaPercentage: UILabel!
    @IBOutlet weak var sativaPercentage: UILabel!
    @IBOutlet weak var thcPercentage: UILabel!
    @IBOutlet weak var growDifficulty: UILabel!
    @IBOutlet weak var amountSelected: UIPickerView!
    
    @IBAction func removeButtonPressed(sender: UIButton) {
    }
    
    //get current user
    func getCurrentUser() {
        let string = "http://lithubb.herokuapp.com/currentUser"
        Alamofire.request(.GET, string)
            .responseJSON { request, response, result in switch result {
                case .Success(let data):
                    let user = JSON(data)
                    print("user info", user)
                    self.currentUserId = String(user["id"])
                    self.email = String(user["email"])
                    print("current user ID", self.currentUserId)
                    print("current user email", self.email)
                case .Failure(_, let error):
                    print("There was an error getting your user information")
                    }
            }
    }
    
    //add an order
    @IBAction func addButtonPressed(sender: UIButton) {
        let row = amountSelected.selectedRowInComponent(0)
        let string = "http://lithubb.herokuapp.com/addOrder"
        var gram = "0"
        var eight = "0"
        var quarter = "0"
        var half = "0"
        var oz = "0"
        switch row {
        case 0:
            gram = "1"
        case 1:
            eight = "1"
        case 2:
            quarter = "1"
        case 3:
            half = "1"
        case 4:
            oz = "1"
        default:
            print("error. default thrown in switch case in productViewController")
        }
        print("this is the item row selected", row)
        let date = String(NSDate())
        let orderData = ["status": 0, "created_at": date, "updated_at": date, "user_id": currentUserId!, "vendor_id": menuItem.vendorID, "quantity_gram": gram, "quantity_eigth": eight, "quantity_quarter": quarter, "quantity_half": half, "quantity_oz": oz, "strain_id": menuItem.strainID]
        //Alamofire request
        Alamofire.request(.POST, string, parameters: orderData as! [String : AnyObject], encoding: .JSON)
            .responseJSON { request, response, result in switch result {
            case .Success(let data):
                print("Order input was a success. This should be empty", data)
            case .Failure(_, let error):
                print("There was an error submitting order information")
                }
        }
//        if let urlToReq = NSURL(string: "http://192.168.1.146:8081/addOrder") {
//            let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
//            request.HTTPMethod = "POST"
//            // Get weight
//            var gram = "0"
//            var eight = "0"
//            var quarter = "0"
//            var half = "0"
//            var oz = "0"
//            switch row {
//            case 0:
//                gram = "1"
//            case 1:
//                eight = "1"
//            case 2:
//                quarter = "1"
//            case 3:
//                half = "1"
//            case 4:
//                oz = "1"
//            default:
//                print("error. default thrown in switch case in productViewController")
//            }
//            // Get all info from textfields to send to node server
//            let date = NSDate()
//            let bodyData = "status=0&created_at=\(date)&updated_at=\(date)&user_id=\(id)&vendor_id=\(menuItem.vendorID)&quantity_gram=\(gram)&quantity_eigth=\(eight)&quantity_quarter=\(quarter)&quantity_half=\(half)&quantity_oz=\(oz)&strain_id=\(menuItem.strainID)"
//            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
//                (response, data, error) in
//                let dataToPrint = JSON(data: data!)
//                print(dataToPrint,"here")
//                print(dataToPrint.type)
//            }
//            
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
//        getOrder()
        self.amountSelected.delegate = self
        self.amountSelected.dataSource = self
        
        productName.title = menuItem.strainName
        productDescription.text = menuItem.description
        growDifficulty.text = menuItem.growDifficulty
        let priceGram = "Price per gram: $" + String(menuItem.priceGram)
        let priceEigth = "Price per eigth: $" + String(menuItem.priceEigth)
        let priceQuarter = "Price per quarter: $" + String(menuItem.priceQuarter)
        let priceHalf = "Price per half: $" + String(menuItem.priceHalf)
        let priceOz = "Price per oz: $:" + String(menuItem.priceOz)
        self.amountSelectedData.append(priceGram)
        self.amountSelectedData.append(priceEigth)
        self.amountSelectedData.append(priceQuarter)
        self.amountSelectedData.append(priceHalf)
        self.amountSelectedData.append(priceOz)
        print(menuItem.fullsize_img1)
        
        if let url = NSURL(string: self.menuItem.fullsize_img1! ) {
            if let data = NSData(contentsOfURL: url){
                self.productImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.productImage.image = UIImage(data: data)
            }
        }
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amountSelectedData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amountSelectedData[row]
    }
    
    
//    modularize this later DRY :)
    
//    func getOrder() {
//        if let urlToReq = NSURL(string: "http://192.168.1.146:8081/getReservations"){
//            let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
//            request.HTTPMethod = "POST"
//            let bodyData = "id=\(Int(id)!)"
//            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
//                (response, data, error) in
//                let realData = JSON(data: data!)
//                print(realData)
//            }
//        }
//    }
    
}
