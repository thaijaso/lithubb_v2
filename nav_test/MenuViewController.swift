//
//  MenuController.swift
//  nav_test
//
//  Created by mac on 9/16/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import GoogleMaps

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var menu = [Menu]()
    var menuFiltered = [Menu]()
    var myMarker : GMSMarker!
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var dispensaryName: UINavigationItem!
    
    
    @IBAction func filterButtonPressed(sender: UIButton) {
        menuFiltered = [Menu]()
        if sender.tag == 1 {
            filter("Indica")
        } else if sender.tag == 2{
            filter("Hybrid")
        } else if sender.tag == 3{
            filter("Sativa")
        } else if sender.tag == 4{
            filter("Edibles")
        } else if sender.tag == 5 {
            filter("Other")
        }
        productTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dispensaryID = String(myMarker.userData)
        if let urlToReq = NSURL(string: "http://192.168.1.140:7000/getMenu/" + dispensaryID) {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfProducts = JSON(data: data)
                dispensaryName.title = arrOfProducts[0]["name"].string
                for var i = 0; i < arrOfProducts.count; ++i {
                    let dispensaryName = arrOfProducts[i]["name"].string
                    let strainID = arrOfProducts[i]["strain_id"].int
                    let strainName = arrOfProducts[i]["strain_name"].string
                    let vendorID = arrOfProducts[i]["vendor_id"].int
                    let priceGram = arrOfProducts[i]["price_gram"].double
                    let priceEigth = arrOfProducts[i]["price_eigth"].double
                    let priceQuarter = arrOfProducts[i]["price_quarter"].double
                    let priceHalf = arrOfProducts[i]["price_half"].double
                    let priceOz = arrOfProducts[i]["price_oz"].double
                    let category = arrOfProducts[i]["category"].string
                    let symbol = arrOfProducts[i]["symbol"].string
                    let description = arrOfProducts[i]["description"].string
                    let fullImage = arrOfProducts[i]["fullsize_img1"].string
                    
                    let dispensaryMenu = Menu(dispensaryName: dispensaryName!, strainID: strainID!, vendorID: vendorID!, priceGram: priceGram!, priceEigth: priceEigth!, priceQuarter: priceQuarter!, priceHalf: priceHalf!, priceOz: priceOz!, strainName: strainName!, category: category!, description: description!)
                    menu.append(dispensaryMenu)
                }
            }
        }
        productTableView.dataSource = self
        productTableView.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            return arrOfObjects
        } catch {
            print(error)
            return nil
        }
    }
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuFiltered.count == 0 {
            return menu.count
        } else {
            return menuFiltered.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier("StrainCell") as? StrainCell
        print("after cell\(cell)")
        if menuFiltered.count != 0 {
            cell!.nameLabel?.text = menuFiltered[indexPath.row].strainName as? String
        } else {
            cell!.nameLabel?.text = menu[indexPath.row].strainName as? String
        }
        return cell!
    }
    
    func filter(filter: String){
        for product in menu {
            if product.category as! String == filter {
                menuFiltered.append(product)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowProduct", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    
    
}
