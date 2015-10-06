//
//  MenuController.swift
//  nav_test
//
//  Created by mac on 9/16/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var menu = [Menu]()
    var menuFiltered = [Menu]()
    var myMarker : GMSMarker?
    var dispensary : Dispensary?
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var dispensaryName: UINavigationItem!
    @IBOutlet weak var indicaButton: UIButton!
    @IBOutlet weak var hybridButton: UIButton!
    @IBOutlet weak var sativaButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var edibleButton: UIButton!
    
    
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
        //product tableView source and delegate
        self.productTableView.dataSource = self
        self.productTableView.delegate = self
        getMenu()
        setImages()
        productTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuFiltered.count == 0 {
            print("drawing the table, the count of menu is", menu.count)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowProduct", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let productViewController = segue.destinationViewController as! ProductViewController
        if let indexPath = productTableView.indexPathForCell(sender as! UITableViewCell) {
            productViewController.menuItem = menu[indexPath.row]
        }

        
    }
    
    func filter(filter: String){
        for product in menu {
            if product.category as! String == filter {
                menuFiltered.append(product)
            }
        }
    }
    
    func getMenu() {
        let dispensary: Dispensary?
        let dispensaryID: String?
        
        if myMarker?.userData != nil {
            dispensary = myMarker!.userData! as! Dispensary
            print(dispensary!)
            dispensaryID = String(dispensary!.id)
            print(dispensaryID)
        } else {
            //dispensaryID = String(dispensary!.id)
            dispensaryID = "1"
        }
        //print("this is the id", dispensaryID)
        
        
        //Alamo fire http request for the items disp carries
        let string = "http://lithubb.herokuapp.com/getMenu/\(dispensaryID!)"
        print(string)
        Alamofire.request(.GET, string)
            .responseJSON { request, response, result in switch result {
            //Runs if success
            case .Success(let data):
                print("Checked for disp items, success")
                let arrOfProducts = JSON(data)
                if arrOfProducts.count != 0 {
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
                        dispensaryMenu.fullsize_img1 = fullImage
                        self.menu.append(dispensaryMenu)
                    }
                    self.dispensaryName.title = self.menu[0].dispensaryName
                    print("printing the menu count", self.menu.count)
                    self.productTableView.reloadData()
                } else {
                    print("there were no items")
                }

            //Failure case
            case .Failure(_, let error):
                print("There was an error getting your user information")
                }
        }
        //End alamofire
    }
    //end getMenu func
    
    func setImages() {
        // set images and text for buttons
        edibleButton.setBackgroundImage(UIImage(named: "edibles"), forState: UIControlState.Normal)
        let ediblesAttributedTitle = NSAttributedString(string: "edibles",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(23.0)])
        edibleButton.setAttributedTitle(ediblesAttributedTitle, forState: .Normal)
        indicaButton.setBackgroundImage(UIImage(named: "indica"), forState: .Normal)
        let indicaAttributedTitle = NSAttributedString(string: "indica",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(23.0)])
        indicaButton.setAttributedTitle(indicaAttributedTitle, forState: .Normal)
        sativaButton.setBackgroundImage(UIImage(named: "sativa"), forState: .Normal)
        let sativaAttributedTitle = NSAttributedString(string: "sativa",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(23.0)])
        sativaButton.setAttributedTitle(sativaAttributedTitle, forState: .Normal)
        hybridButton.setBackgroundImage(UIImage(named: "hybrid"), forState: .Normal)
        let hybridAttributedTitle = NSAttributedString(string: "hybrid",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(23.0)])
        hybridButton.setAttributedTitle(hybridAttributedTitle, forState: .Normal)
        otherButton.setBackgroundImage(UIImage(named: "other"), forState: .Normal)
        let otherAttributedTitle = NSAttributedString(string: "other",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(23.0)])
        otherButton.setAttributedTitle(otherAttributedTitle, forState: .Normal)
    }
    
}
