//
//  DispensariesViewController.swift
//  nav_test
//
//  Created by mac on 9/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class DispensariesViewController: UITableViewController {
    
    
    var dispensaries = [Dispensary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDispensaries()
    }
    
    func requestDispensaries() {
        if let urlToReq = NSURL(string: "http://192.168.1.145:7000/dispensaries") {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfDispensaries = parseJSON(data)
                print(arrOfDispensaries, "arrrrrr")
                for dispensary in arrOfDispensaries! {
                    let object = dispensary as! NSDictionary
                    let id = object["id"] as! Int
                    let name = object["name"] as! String
                    let address = object["address"] as! String
                    let phone = object["phone"] as! String
                    let city = object["City"] as! String
                    let state = object["State"] as! String
                    let logo = object["logo"] as! String
                    //let latitude = object["latitude"] as! Double
                    //let longitude = object["longitude"] as! Double
                    let dispensaryToAppend = Dispensary(id: id, name: name, address: address, city: city, state: state, phone: phone, logo: logo)
                    dispensaries.append(dispensaryToAppend)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            var arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            return arrOfObjects
        } catch {
            print(error)
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dispensaries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DispensaryCell") as! DispensaryCell
        let dispensary = dispensaries[indexPath.row]
        //print(NSThread.isMainThread() ? "Main Thread" : "Not on Main Thread")
        cell.dispensaryName!.text = dispensary.name
        cell.dispensaryPhone!.text = dispensary.phone
        cell.dispensaryStreetAddress!.text = dispensary.address
        cell.dispensaryCityState!.text = dispensary.city.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + ", " + dispensary.state
//        cell.dispensaryHours!.text = dispensary.hours
       print(dispensary.logo, "cat")
        
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: dispensary.logo)!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                // Update the cell
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        cell.dispensaryLogo.image = UIImage(data: data!)
                    }
                })
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
        })
        return cell
    }
    
    

}