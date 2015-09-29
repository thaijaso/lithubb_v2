//
//  DispensariesViewController.swift
//  nav_test
//
//  Created by Vikash Loomba on 9/28/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import UIKit

class DispensariesViewController: UIViewController {
    //Container View variables
    @IBOutlet weak var mapViewContainer: UIView!
    
    @IBOutlet weak var listViewContainer: UIView!
    
    //Segmented controls var and func
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        if(segmentedControl.selectedSegmentIndex == 0) {
            listViewContainer.hidden = true
            mapViewContainer.hidden = false
            print("the map is showing")
        }
        else if(segmentedControl.selectedSegmentIndex == 1) {
            mapViewContainer.hidden = true
            listViewContainer.hidden = false
            print("the list is showing")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewContainer.hidden = true
    }
}