//
//  Dispensary.swift
//  nav_test
//
//  Created by mac on 9/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

class Dispensary {
    var id: Int
    var name: String
    var address: String
    var city: String
    var state: String
    var latitude: Double?
    var longitude: Double?
    var phone: String
    //var hours: String
    
    init(id: Int, name: String, address: String, city: String, state: String, phone: String) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        //self.latitude = latitude
        //self.longitude = longitude
        self.phone = phone
    }
}