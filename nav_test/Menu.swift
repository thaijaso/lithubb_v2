//
//  Menu.swift
//  nav_test
//
//  Created by mac on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

class Menu {
    var dispensaryName: String
    var strainID: Int
    var vendorID: Int
    var priceGram: Double
    var priceEigth: Double
    var priceQuarter: Double
    var priceHalf: Double
    var priceOz: Double
    var strainName: String
    var category: String
    var description: String
    var symbol: String?
    var starImage: String?
    var thumbImage1: String?
    var thumbImage2: String?
    var thumbImage3: String?
    var thumbImage4: String?
    var fullsize_img1: String?
    var fullsize_img2: String?
    var fullsize_img3: String?
    var fullsize_img4: String?
    var test_graph: String?
    var effects1: Double?
    var effects2: Double?
    var effects3: Double?
    var effects4: Double?
    var effects5: Double?
    var medical1: Double?
    var medical2: Double?
    var medical3: Double?
    var medical4: Double?
    var medical5: Double?
    var negatives1: Double?
    var negatives2: Double?
    var negatives3: Double?
    var negatives4: Double?
    var negatives5: Double?
    var growDifficulty: String?
    
    init(dispensaryName: String, strainID: Int, vendorID: Int, priceGram: Double, priceEigth: Double, priceQuarter: Double, priceHalf: Double, priceOz: Double, strainName: String, category: String, description: String) {
        self.dispensaryName = dispensaryName
        self.strainID = strainID
        self.vendorID = vendorID
        self.priceGram = priceGram
        self.priceEigth = priceEigth
        self.priceQuarter = priceQuarter
        self.priceHalf = priceHalf
        self.priceOz = priceOz
        self.strainName = strainName
        self.category = category
        self.description = description
    }
}