//
//  DispensaryCell.swift
//  nav_test
//
//  Created by mac on 9/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class DispensaryCell: UITableViewCell {
    @IBOutlet weak var dispensaryLogo: UIImageView!
    @IBOutlet weak var dispensaryName: UILabel!
    @IBOutlet weak var dispensaryStreetAddress: UILabel!
    @IBOutlet weak var dispensaryCityState: UILabel!
    @IBOutlet weak var dispensaryHours: UILabel!
    @IBOutlet weak var dispensaryRating: UIImageView!
    @IBOutlet weak var dispensaryPhone: UILabel!
    var dispensaryId: Int!
    
}
