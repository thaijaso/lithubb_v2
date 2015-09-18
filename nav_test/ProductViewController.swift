//
//  ProductViewController.swift
//  nav_test
//
//  Created by mac on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    var menuItem: Menu!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var indicaPercentage: UILabel!
    @IBOutlet weak var sativaPercentage: UILabel!
    @IBOutlet weak var thcPercentage: UILabel!
    @IBOutlet weak var growDifficulty: UILabel!
    @IBOutlet weak var amountSelected: UIPickerView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
