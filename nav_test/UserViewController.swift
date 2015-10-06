//
//  UserViewController.swift
//  nav_test
//
//  Created by Vikash Loomba on 9/28/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



class UserViewController: UIViewController {
    @IBOutlet weak var userEmailLabel: UILabel!
    
    let keychain = KeychainSwift()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userEmail = keychain.get("email")
        if userEmail != nil {
            userEmailLabel.text = userEmail!
        }
        
    }
    
}
