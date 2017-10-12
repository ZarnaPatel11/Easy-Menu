//
//  Section.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 29/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    var orderDateSection:[String]
    var orderDetail:[[String:String]]
    
    init(orderDateSection:[String], orderDetail:[[String:String]]) {
        self.orderDateSection = orderDateSection
        self.orderDetail = orderDetail
    }
}

struct Item {
    var items:String
    var itemName:[String]
    
    init(items:String, itemName:[String]) {
        self.items = items
        self.itemName = itemName
    }
}

struct HotelDetails {
    let hotel_name: String!
    let persons: String!
    let date: String!
    let orderId: String!
}

struct ItemDetails {
    let item_category: String!
    let item_name: String!
}
