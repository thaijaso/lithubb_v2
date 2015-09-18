//
//  ProductViewController.swift
//  nav_test
//
//  Created by mac on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var menuItem: Menu!
    var amountSelectedData = [String]()
    
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
    
    @IBAction func addButtonPressed(sender: UIButton) {
        let row = self.amountSelected.selectedRowInComponent(0)
        print(row)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
