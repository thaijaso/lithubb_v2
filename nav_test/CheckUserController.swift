//
//  CheckUserController.swift
//  nav_test
//
//  Created by Vikash Loomba on 10/2/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import UIKit

class CheckUserController: UINavigationController {
    let keychain = KeychainSwift()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userEmail = keychain.get("email")
        print("users email: ", userEmail)
        if userEmail != nil {
            performSegueWithIdentifier("previouslyLoggedin", sender: nil)
        } else {
            performSegueWithIdentifier("pleaseLogIn", sender: nil)
        }
    }
}