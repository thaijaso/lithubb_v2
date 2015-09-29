//
//  DispensariesViewController.swift
//  nav_test
//
//  Created by mac on 9/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Alamofire


class DispensariesViewController: UITableViewController {
    
    
    var dispensaries = [Dispensary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDispensaries()
    }
    
    func requestDispensaries() {
        let string = "http://lithubb.herokuapp.com/dispensaries"
        //print(string)
        Alamofire.request(.GET, string)
            .responseJSON { request, response, result in
                switch result {
                case .Success(let data):
                    let arrayOfDispensaries = JSON(data)
                    for var i = 0; i < arrayOfDispensaries.count; ++i {
                        let dispensaryID = arrayOfDispensaries[i]["id"].int
                        let dispensaryName = arrayOfDispensaries[i]["name"].string
                        let dispensaryLat = arrayOfDispensaries[i]["lat"].double
                        let dispensaryLng = arrayOfDispensaries[i]["lng"].double
                        let dispensaryAdd = arrayOfDispensaries[i]["address"].string
                        let dispensaryState = arrayOfDispensaries[i]["State"].string
                        let dispensaryCity = arrayOfDispensaries[i]["City"].string
                        let dispensaryPhone = arrayOfDispensaries[i]["phone"].string
                        let dispensaryLogo = arrayOfDispensaries[i]["logo"].string
                        let dispensary = Dispensary(id: dispensaryID!, name: dispensaryName!, address: dispensaryAdd!, city: dispensaryCity!, state: dispensaryState!, phone: dispensaryPhone!, logo: dispensaryLogo!)
                        dispensary.latitude = dispensaryLat!
                        dispensary.longitude = dispensaryLng!
                        self.dispensaries.append(dispensary)
                    }
                case .Failure(_, let error):
                    print("Request failed with error: \(error)")
                    
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